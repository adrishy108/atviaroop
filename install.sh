# Specify the target directory for the script
TARGET_DIRECTORY="/usr/local/bin"

# Specify the name of the script
SCRIPT_NAME="ativaroop.sh"
SHORT_NAME="ar"

# Check if the script requires root permissions
if [ "$EUID" -ne 0 ]; then
  echo "Please run the installation script as root or using sudo."
  exit 1
fi

# Check if the script file exists
if [ ! -f "${SCRIPT_NAME}" ]; then
  echo "Error: The script '${SCRIPT_NAME}' does not exist. Make sure it's in the same directory as the installation script."
  exit 1
fi

# Copy the script to the target directory
cp "${SCRIPT_NAME}" "${TARGET_DIRECTORY}/"

# Check if the copy operation was successful
if [ $? -ne 0 ]; then
  echo "Error: Unable to copy the script to ${TARGET_DIRECTORY}/."
  exit 1
fi

# Ensure the script has executable permissions
chmod +x "${TARGET_DIRECTORY}/${SCRIPT_NAME}"

# Check if setting executable permissions was successful
if [ $? -ne 0 ]; then
  echo "Error: Unable to set executable permissions for ${SCRIPT_NAME}."
  exit 1
fi

# Create a symbolic link with a shorter name
ln -s "${TARGET_DIRECTORY}/${SCRIPT_NAME}" "${TARGET_DIRECTORY}/${SHORT_NAME}"

echo "Installation complete. You can now use '${SHORT_NAME}' or '${SCRIPT_NAME}' from the command line."
