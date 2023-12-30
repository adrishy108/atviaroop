# Website Scraping and Conversion Script

This Bash script allows you to scrape a website and convert its HTML content to Markdown or plain text. It provides flexibility through various options for customization.


### Installation Guide for atviaroop

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/atviaroop.git
   cd atviaroop
   ```

2. **Run the Installation Script:**
   ```bash
   sudo bash install.sh
   ```
   This script installs the `ativaroop.sh` script to `/usr/local/bin/` and makes it executable.

3. **Usage Instructions:**
   - Once installed, you can use the `ativaroop.sh` script from the command line.
   - Run `ativaroop.sh` with the desired options and a website URL. For example:
     ```bash
     ativaroop.sh -o output_directory -m -t -c https://example.com
     ```
     - `-o`: Specify the output directory (default is "website").
     - `-m`: Convert HTML to Markdown.
     - `-t`: Convert plain text to Markdown.
     - `-c`: Keep HTML files after conversion.

4. **View Logs (Optional):**
   - If needed, check the log file for details:
     ```bash
     cat scrape_log_<timestamp>.txt
     ```

5. **Uninstall (Optional):**
   - If you wish to uninstall the script, you can manually remove it from `/usr/local/bin/`:
     ```bash
     sudo rm /usr/local/bin/ativaroop.sh
     ```

Note: Ensure that your users have the necessary permissions to run the installation script and execute the installed script. Also, they should have required dependencies like `wget` and `pandoc` installed on their system.

### Options

- `-o <output_directory>`: Specify the output directory (default: website)
- `-m`: Convert HTML to Markdown (default: plain text)
- `-t`: Convert plain text to Markdown (default: no conversion)
- `-c`: Keep HTML files after conversion (default: remove)

### Example

```bash
ar -o output -m https://example.com
```

For detailed usage information, run:

Download and convert a website:

```bash
ar -o my_website -m -c https://example.com
```

Feel free to customize the script according to your specific needs.
