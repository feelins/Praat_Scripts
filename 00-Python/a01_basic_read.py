import textgrid as tg

tgrid = tg.read_textgrid(r'E:\Biaobei_Demo\000001.TextGrid', 'Phon')
for entry in tgrid:
    print(entry.name)
print(len(tgrid))
print('Done!')