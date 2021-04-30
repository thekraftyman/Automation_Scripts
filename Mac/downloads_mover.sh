#!/bin/bash

# Program that moves items from the downloads folder to a better place

# Go to downloads folder
cd ~/Downloads/

# Move any downloaded images to the pictures folder for easier management of downloads folder
mv *.jpg ~/Pictures/Downloads/
mv *.png ~/Pictures/Downloads/
mv *.gif ~/Pictures/Downloads/

# Move any pdfs to the PDFs folder in Documents
mv *.pdf ~/Documents/PDFs/

# Move any word files to the Word_Files folder in Documents
mv *.doc ~/Documents/Word_Files/
mv *.docx ~/Documents/Word_Files/

# Move any excel files to the Excel_Files folder in Documents
mv *.xls ~/Documents/Excel_Files/

# Move any csvs to the CSVs folder in Documents
mv *.csv ~/Documents/CSVs/

# Move any databases
mv *.sql ~/Documents/form_and_database_backups/

# Move any virtual machine apps or OS images
mv *.ova ~/Documents/virtual_machines/
mv *.iso ~/Document/OS_Images/
mv *.img ~/Document/OS_Images/

# Move any Photoshop files
mv *.psd ~/Documents/Photoshop/
