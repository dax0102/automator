import 'package:automator/shared/custom/header.dart';
import 'package:automator/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class GuidesPage extends StatelessWidget {
  const GuidesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ThemeComponents.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(title: Translations.of(context)!.navigation_guides),
          const Expanded(child: Markdown(data: _notes))
        ],
      ),
    );
  }

  static const String _notes = """
## Notes
This build of Automator is specifically built for Führerredux (and maybe 
sibling mods such as Kaiserredux and the OG Führerreich. This tool aims 
to lift the workload of the modders in creating the characters for a 
specified country. However, the ideologies using by Führerredux are hard-coded
in this tool, and there maybe plans to override this behavior.

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
there are three ways in adding characters. One is adding a single character
through the character editor clicking the "Add" button, this is ideal when 
adding or editing single characters, not ideal when creating batches. 
The other one is adding through the "Importer", by clicking the "Import" button,
this needs a CSV file, containing the names of the characters.

Sample content of CSV file:
```
Rodrigo Duterte,Emmanuel Pacquiao,Ferdinand Marcos Jr.
```

And the final one if through extracting the names in the localization files. 
This only work for idea-style ministers though, and will parse the names based
on the prefixes of the positions of the ministers, (Head of Government is `hog`).

Sample Idea-Style Minister Localization file:
```yaml
PHI_Rodrigo_Duterte_hog_sde:0 "Rodrigo Duterte"
PHI_Ferdinand_Marcos_Jr_hog_sde:0 "Ferdinand Marcos Jr."
PHI_Emmanuel_Pacquiao_hog_sco:0 "Emmanuel Pacquiao"
```

A successfull import will direct you to a screen where you can tweak the details
of the character such as their positions, ideology and current status.

---

### I added the characters, now what?
If you are done in tweaking the characters, you can export it by clicking the
"Export" button. This prompts you to save the file; and wait for the task to
finish. You can rename the file if you want and view the file for vertification.
If you're done, put it in the 'common/characters/' folder.

---

### What is the difference between the Characters and Ministers
The Character tool is used to generate the new character system in the Barbarossa
patch; while the minister tool is used to generate the old-style ministers from 
Kaiserreich and Kaiserredux using the idea system. It will generate not just the 
idea, but also the localization files and the GFX spriteType definitions.

---

### What are traits?
Traits are for the minister traits of Führerredux. If it's not empty you will
be presented to select one rather than manually inputting it when creating or
importing characters.

---

### Why I can't add traits individually?
You'll need to import them from file, commonly found in 'common/country_leaders/00_minister_traits.txt'.
Select that file and you will be presented its contents; assuming it's correct.

---

### How about the leader and commander traits from Vanilla?
Those traits are not supported yet, so you'll need to enter them manually.

---

### I encountered an error
If you encounted an error such as the tool crashed or the generated file is
invalid, report it to me. Do note that I need to know what you are doing so
that I could debug it.

---

### I work on another mod; but this tool looks promising
If you work on another mod which does not a sibling of the original Kaiserreich
and Führreich mods; but wanted to use this tool for automating the creation of
either your characters or ministers; you may take note that the `Ideologies` 
defined in the tool are hardcoded; which means if you have different ideologies
in your mod, the tool may not work. However, you can either fork this tool, and 
modify the ideology definitions yourself; and compile it again, or manually
`Find and Replace + Replace All` the ideologies in the generated file; which is
kinda defeats the whole purpose of the tool. If you need to contact me, just
join the Führerredux Server and DM or mention me there.

---

### Where's the invite link tho?
Here it is: [Führerredux Discord Server](https://discord.gg/dVT7bHNVgY)

""";
}
