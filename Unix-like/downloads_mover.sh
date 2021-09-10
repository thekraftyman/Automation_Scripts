#!/bin/bash

# Program that moves items from the downloads folder to a better place

# Go to downloads folder
cd ~/Downloads/

# Move any downloaded images to the pictures folder for easier management of downloads folder
mv *.jpg ~/Pictures/Downloads/
mv *.png ~/Pictures/Downloads/
mv *.gif ~/Pictures/Downloads/
mv *.jpeg ~/Pictures/Downloads/
mv *.JPG ~/Pictures/Downloads/

# Move any pdfs to the PDFs folder in Documents
mv *.pdf ~/Documents/pdfs/

# Move any word files to the Word_Files folder in Documents
mv *.doc ~/Documents/word_files/
mv *.docx ~/Documents/word_files/

# Move any excel files to the Excel_Files folder in Documents
mv *.xls ~/Documents/excel_files/

# Move any csvs to the CSVs folder in Documents
mv *.csv ~/Documents/csvs/

# Move any databases
mv *.sql ~/Documents/form_and_database_backups/

# Move any virtual machine apps or OS images
mv *.ova ~/Documents/virtual_machines/
mv *.iso ~/Document/os_images/
mv *.img ~/Document/os_images/

# Move any Photoshop files
mv *.psd ~/Documents/photoshop/
