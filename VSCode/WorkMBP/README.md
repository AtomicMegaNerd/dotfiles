# Chris Dunphy's VSCode configuration

## Deploy New Instance of Code

First run the extensions.sh script included in the file.

If you need to updae this list run this command to list the currently installed extenions:

```bash
code --list-extensions | xargs -L 1 echo code --install-extension
```

You may need to restart after this step.

Next, simply copy the contents of the JSON file into the settings in VSCode to apply them.
