# SkillSync AI Tutor Test Server

This local server lets the SkillSync iPhone app use OpenAI without putting the
private API key inside the app.

## Start the tutor

1. Keep the Mac and iPhone connected to the same Wi-Fi network.
2. Double-click `start-tutor.command`.
3. Paste the OpenAI API key into the Terminal prompt and press Return. The key
   is hidden while it is entered and is not saved to a file.
4. If macOS asks whether Python can accept incoming connections, choose
   **Allow**.
5. Keep the Terminal window open while using the AI Tutor on the iPhone.

The first time the iPhone connects, iOS may ask for local-network permission.
Choose **Allow**.

## Stop the tutor

Return to the Terminal window and press Control-C.

## Security

- Never put the OpenAI API key in Swift code.
- Never add the key to this repository.
- This server keeps no chat database and sends requests with `store: false`.
- The server is meant for local testing. A released app should use an
  authenticated HTTPS backend instead.
