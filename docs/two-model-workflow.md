# SkillSync Two-Model Workflow

SkillSync's pixel-game development workflow uses two different AI models with
different responsibilities. Codex (the ChatGPT coding model) understands the
app and coordinates the work. PixelLab's image-generation model creates the
pixel artwork and animations.

## Which model understands the SkillSync game requirements?

Codex understands the SkillSync game requirements. It reads the user's
instructions, examines the Xcode project, understands how Pixel Quest should
work, and decides what code or artwork is needed.

PixelLab does not automatically understand the entire SkillSync project. It
only receives the specific art request and settings that Codex sends to it.

## Which model creates the pixel image?

PixelLab's AI image-generation model creates the pixel image, tileset,
character, or animation. Codex requests the asset and then imports the
completed result into the SkillSync Xcode project.

## Do the two models directly chat with each other?

No. The models do not have an independent conversation with each other.
Codex uses PixelLab's MCP tools to send a structured request. PixelLab processes
that request and returns a job status, identifiers, download links, metadata,
and generated assets. Codex then reads those results and decides what to do
next.

The MCP server acts as the controlled bridge between the two systems.

## What structured information passes between them?

The information begins with the user's instructions, but Codex converts those
instructions into a more structured PixelLab request. That request can include:

- A detailed description of the requested artwork.
- Image or tile dimensions.
- Camera angle and viewing direction.
- Number of character directions or animation frames.
- Pixel-art detail, shading, and outline styles.
- Color-palette or reference-image information.
- Animation actions, such as walking or idling.
- Tileset terrain types and transition rules.
- Generation seeds and other consistency settings.

PixelLab returns structured information such as:

- A job, character, object, or tileset identifier.
- Processing status and estimated completion time.
- Generated image and animation files.
- Direction and frame information.
- Tileset placement metadata.
- Download links and error messages.

## What happens if the PixelLab service is unavailable?

Codex cannot use PixelLab's tools to generate, edit, or download new PixelLab
assets while the service is unavailable. New PixelLab art work must wait until
the connection or service becomes available again.

However, SkillSync does not require a live PixelLab connection when a player
runs the app. Assets that were already generated, downloaded, and added to the
Xcode project remain bundled with the app and continue working.

## Which game components should continue working without PixelLab?

All runtime game features that use existing local code and downloaded assets
should continue working, including:

- Opening Pixel Quest and playing its transition.
- Displaying the existing map, robot, resources, and animations.
- Moving the robot and changing its direction.
- Collecting iron and carbon.
- Updating the inventory.
- Crafting the steel sword.
- Showing the steel learning explanation.
- Restarting the quest.
- Using the rest of SkillSync, including login, progress, the periodic table,
  and the AI tutor when its own server is available.

Only the creation or revision of new PixelLab artwork depends on PixelLab being
available.
