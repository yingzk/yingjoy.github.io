---
title: Python 合并PDF
date: 2022-11-10 09:12:33
en_title: Python Merge pdf
tags:
---

```python
import os
from PyPDF2 import PdfFileMerger

target_path = 'Desktop'
pdf_lst = [f for f in os.listdir(target_path) if f.endswith('.pdf')]
pdf_lst = [os.path.join(target_path, filename) for filename in pdf_lst]

file_merger = PdfFileMerger()
for pdf in pdf_lst:
    file_merger.append(pdf)

file_merger.write("merge.pdf")
```