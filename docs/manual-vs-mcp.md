# Manual and MCP PixelLab Workflows

## Purpose

PixelLab can be used either through its website or through a Model Context
Protocol (MCP) connection. Both workflows use PixelLab to generate pixel-art
assets, but MCP lets a local AI coding agent coordinate more of the process.

MCP does not turn the coding model into an image-generation model. It gives the
coding model permission to request work from PixelLab's separate
asset-generation service.

## Workflow Without MCP

```text
Student
  → Opens the PixelLab website
  → Signs in
  → Selects a generation tool
  → Writes an asset prompt
  → Generates and reviews the asset
  → Downloads the file
  → Moves and renames the file
  → Imports the file into Xcode
  → Updates the Swift code
  → Tests the asset in SkillSync
```

This workflow gives the student direct control over every step, but repeatedly
downloading, organizing, and importing files takes additional time.

## Workflow With MCP

```text
Student
  → Describes the required game asset to the local AI coding agent
  → Coding agent sends a structured MCP tool call
  → PixelLab MCP server authenticates and forwards the request
  → PixelLab generation model creates the pixel art
  → Generated asset returns to the coding agent
  → Student reviews and approves the result
  → Coding agent organizes and integrates the asset into SkillSync
  → Student tests the result in Xcode
```

The student still controls the creative direction and approves the final
asset. MCP primarily removes repetitive transfer and integration steps.

## Responsibilities

### PixelLab Website

The website provides a visual, browser-based interface for PixelLab. It allows
the student to create and manage characters, animations, items, maps, and
tilesets manually. It is also where the student signs in and obtains the
private token needed for MCP access.

### Local AI Coding Agent

The coding agent, Codex in this project, understands the SkillSync codebase and
the game's requirements. It can:

- Turn a game requirement into a detailed asset prompt.
- Select an appropriate PixelLab tool.
- Make the MCP tool call.
- Save and organize the returned asset.
- Add the approved asset to the Xcode project.
- Update Swift or SpriteKit code to use the asset.
- Test the integration and explain any errors.

The coding agent coordinates the workflow, but it does not directly generate
the PixelLab image.

### PixelLab MCP Server

The MCP server is the bridge between Codex and PixelLab. It:

- Publishes PixelLab's available tools in a format Codex can understand.
- Receives structured tool requests from Codex.
- Checks the authentication token.
- Sends valid requests to PixelLab's generation service.
- Returns generated assets and metadata to Codex.
- Reports errors such as invalid authentication or insufficient credits.

For this project, the public PixelLab MCP endpoint is:

```text
https://api.pixellab.ai/mcp
```

### PixelLab Generation Model

PixelLab's generation model creates the actual pixel-art image or animation.
It follows information such as:

- Asset description
- Dimensions
- Perspective
- Palette
- Outline style
- Lighting direction
- Background requirements
- Animation or directional requirements

The model does not understand the entire SkillSync project unless the coding
agent includes the necessary requirements in its request.

### Authentication Token

The PixelLab token identifies the user's account and authorizes PixelLab MCP
requests. It may also connect generation usage to the account's subscription
or available credits.

The token is a private secret. It must not be:

- Committed to Git or GitHub.
- Written in Swift source code.
- Added to asset prompts or documentation.
- Included in screenshots or demonstrations.
- Shared in chat messages.

Codex should read the token from a private local environment variable or other
secure local configuration.

## Manual Steps Removed or Reduced by MCP

| Step | Manual website workflow | MCP workflow |
| --- | --- | --- |
| Open PixelLab for every request | Required | Usually not required after setup |
| Select a generation tool | Student chooses manually | Codex can choose the appropriate tool |
| Format the prompt | Student writes every setting | Codex can build a structured prompt |
| Download the generated file | Required | Returned through the MCP workflow |
| Move and rename the asset | Required | Codex can organize it automatically |
| Import the asset into Xcode | Required | Codex can perform the project integration |
| Update game code | Student updates it | Codex can update the relevant code |
| Review the artwork | Required | Still required |
| Test the game | Required | Still required |

MCP reduces repeated technical work, but it does not remove human judgment.
The student must still decide whether an asset matches the game's visual
direction and whether it should be included in SkillSync.

## If PixelLab Is Unavailable

If the PixelLab MCP server or generation service is unavailable, new artwork
cannot be generated through MCP. However, SkillSync should still open and its
existing learning system, AI Tutor, periodic table, saved progress, gameplay,
and previously downloaded assets should continue working. PixelLab should be a
development tool, not a service that the finished game requires every time it
runs.
