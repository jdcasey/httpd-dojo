# HTTPd Dojo

This project creates a Docker image that will start an Apache HTTPd instance configured to allow clients to retrieve webserver logs and configurations. It also contains a Python CGI that allow clients to PUT new content on the system or DELETE existing content (eg. calling `PUT /cgi-bin/content.py/path/to/some/file.html`), and another to allow clients to execute arbitrary code as root in order to fine-tune the environment prior to running an automated test (eg. calling `POST /cgi-bin/setup.py` with a shell script as the POST body).

The image is designed to be extended to host specific services, so they can be used by automated tests on the client side.

## WARNING

This image is intentionally insecure. Its purpose is to support automated testing and manual exploration of a system, which requires the following abilities:

* setup initial conditions for a test against the service, by executing arbitrary setup commands as `root`
* setup initial static content to be served by the webserver, for use in automated testing
* download the webserver configuration files for storage alongside test results
* download the webserver logs for storage alongside test results

**This image should NEVER be used as an actual hosting environment. It is EXTREMELY insecure.** You have been warned.

## content.py

This CGI uses the PUT method to read the request body and store it in the sub-path under `/var/www/html` specified by the PATH_INFO of the request. It uses the DELETE method similarly, but to delete content from `/var/www/html` instead.

## setup.py

This CGI listens for POST requests and reads shell script content from the request body. The content is written to a temporary shell script file under `/var/www/html/setup-scripts` then executed as root. Afterward, a timestamp and URL to the written setup script file (calculated using the requested host, port, and the tempfile path) is logged to `/var/www/html/setup-scripts/command.log`. All of these scripts (and the log) are available for the client to download and inspect afterward.

