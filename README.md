# automator

An automated component generation tool for total conversion mods such as Führerredux and Kaiserredux.

## License
This project is licensed under the GPL-3.0 - see the license file for more details

## Contributing
This application is currently under development. Contributions are still welcome but may need more consideration from the maintainers.

## Notes
This build of Automator is specifically built for Führerredux (and maybe 
sibling mods such as Kaiserredux and the OG Führerreich. This tool aims 
to lift the workload of the modders in creating the characters for a 
specified country. However, the ideologies using by Führerredux are hard-coded
in this tool, and there maybe plans to override this behavior. Do note that 
this tool does NOT currently that the data is not persistent; meaning closing
this tool will result in loss of data inserted unto it. Also please be gentle 
as this tool is currently in BETA; and some bugs might exist through-out
(Hopefully not). 

---

### What does Automator do?
Currently, I built Automator to generate the character files used for the
new NSB Patch for Hearts of Iron IV. Führerredux has hundreds-if not thousands
of characters waiting to be refactored for the new patch. This tool aims to
automate that. However, there are more features that are planned to be 
implemented in the future.

---
### How do I automate creation of characters?
While the aim of the creation of this tool is to automate the creation of the
characters used in the mod; there are also manual work involved. Currently,
there are two ways in adding characters. One is adding a single character
through the character editor clicking the "Add" button, this is ideal when 
adding or editing single characters, not ideal when creating batches. 
The other one is adding through the "Importer", by clicking the "Import" button,
this needs a CSV file, containing the names of the characters.

Sample content of CSV file:
```
Rodrigo Duterte,Emmanual Pacquiao,Ferdinand Marcos Jr.
```

A successfull import will direct you to a screen where you can tweak the details
of the character such as their positions, ideology and current status.

---

### I added the characters, now what?
If you are done in tweaking the characters, you can export it by clicking the
"Export" button. This prompts you to save the file; and wait for the task to
finish. You can rename the file if you want and view the file for vertification.
If you're done, put it in the 'common/characters/' folder.