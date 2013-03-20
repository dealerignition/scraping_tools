# Importing Catalogs

- Run the appropriate importer and create .tsv files by copying and pasting the returned content.
- Upload the .tsv files to scraping_tools/tsv_files.
- In the catalogs app either create a new catalog or update an exsiting catalog.
- Choose the approriate tsv files for the form.
- Press 'Update' or 'Create'
- **DEVELOPMENT** The catalog will now be loaded into delayed_jobs. Run `rake jobs:work` to start the import.
- **PRODUCTION** The rest of the import will happen automatically.
- When the process is complete you should be able to view the catalog.

### NOTES
- Ensure tsv files are UTF-8.
- Be sure to replace non-ASCII characters (®, ™, ’, etc.) with an appropriate character or escape code. During the import stage these will be turned into replacement characters (�) and the importer may choke on them.
- You can view import progress by refreshing the catalogs index page.
- Currently there is a bug you may encounter when importing catalogs in production. The best known solution is to restart the catalogs app `heroku restart --app di-catalogs` and then import the catalog.


# Importing Karastan Catalogs

- Follow these steps: https://github.com/dealerignition/dealer_ignition/blob/master/doc/importing-karastan-sql-server-backup-file.markdown
- Next follow the steps above for "Importing Catalogs".