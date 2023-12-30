# Website Scraping and Conversion Script

This Bash script allows you to scrape a website and convert its HTML content to Markdown or plain text. It provides flexibility through various options for customization.


## Options

- `-o <output_directory>`: Specify the output directory (default: website)
- `-m`: Convert HTML to Markdown (default: plain text)
- `-t`: Convert plain text to Markdown (default: no conversion)
- `-c`: Keep HTML files after conversion (default: remove)

## Example

```bash
./website_scrape.sh -o output -m https://example.com
```

For detailed usage information, run:

```bash
./website_scrape.sh -h
```

Feel free to customize the script according to your specific needs.