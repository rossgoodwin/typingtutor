from sys import argv
import math
from goose import Goose

script, url = argv
g = Goose()
article = g.extract(url=url)
text = article.cleaned_text

paragraphs = text.split('\n')
tokens = [p.split(' ') for p in paragraphs]

for p in tokens[:]:
	if len(p) < 3:
		tokens.remove(p)

words = []
for p in tokens:
	words+=p

lines = []
for i in range(int(math.floor(len(words)/10))-1):
	lines.append(words[10*i:10*(i+1)])

last_line = int(math.floor(len(words)/10))*10
lines.append(words[last_line:])

formattedA = [' '.join(l) for l in lines]
formattedB = '\n'.join(formattedA)

f = open('typingtutor/data/article.txt', 'w')
f.write(formattedB.encode('utf8'))
f.close()