# Bacteria_Phenotype
Scripts used to parse gram staining and oxygen tolerance from BacDive database.

One script is used to retrieve information using the BacDive API. This returns a huge file, because a information from the selected bacteria is downloaded. For example, to retrieve all information from Gram-positive bacteria, 130 Mb was required. 

The other script was used to retrieve information using web scraping techniques. This was used to get a list of all bacteria with oxygen tolerance information (about 8k species). The API was returning an error (maybe IP blockage due to excessive requests).

A merged file was generated using Excel, with a list of about 6-7k bacteria with gram-staining or oxygen tolerance information.
