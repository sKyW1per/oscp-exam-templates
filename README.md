# oscp-exam-template
my setup and templates for oscp labs and exam

#### Exam template
Exam md/pdf template based on:
https://github.com/noraj/OSCP-Exam-Report-Template-Markdown

generate_report.sh and zip_report.sh are based on 
https://github.com/JohnHammond/oscp-notetaking

Eisvogel template from
https://github.com/Wandmalfarbe/pandoc-latex-template/releases/tag/v2.0.0

Install requirements with (on debian-based systems):
```
$ apt install texlive-latex-recommended texlive-fonts-extra texlive-latex-extra pandoc p7zip-full
```

Making the pdf report from markdown:
```
$ bash generate_report.sh <input.md> <output.pdf>
```

Naming, making and zipping the report from markdown:
```
$ bash zip_report.sh <input.md>
```

