import re

'''
	TextGrid
		tiers: Object of type Tiers
		raw: raw content of the textgrid

	Tiers
		tiers: Dict with key tier name, value, Tier object
		xmin: float
		xmax: float
		size: integer

		getAnnotations(tier, start, end) -> gets the annotations between start and end
		return is an array of type Annotation

	Tier
		xmin: float
		xmax: float
		name: string
		type: point or interval
		size: integer
		annotations = array of type Annotation

	Annotation
		xmin: float
		xmax: float
		features: Object of type Features

		getFeature(featureName) -> gets the value of the specified feature. 
		returns string since it can be a float or a string.

	Features
		head: string, head. Can be none
		features: dict with key feature name and value, feature value
		rawFeatures: raw string as found in the textgrid
'''

class TextGrid:

	def __init__(self, path):
		self.loadTextGrid(path)
		self.tab ="    "

	def loadTextGrid(self, path):
		fd = open(path,"r")
		raw = fd.read()
		self.raw = raw
		fd.close()

		lines = raw.split("\n")
		self.lines = lines
		start = float(lines[3].split(" = ")[1])
		end = float(lines[4].split(" = ")[1])
		
		self.tiers = Tiers(start, end)

		items = re.split(r'item \[[0-9]*\]', raw)[2:]
		for item in items:
			self.loadTier(item)

	def loadTier(self, raw):
		tierLines = raw.split("\n")[1:]
		name = tierLines[1].strip().split(" = ")[1].replace('"',"")
		start = float(tierLines[2].strip().split(" = ")[1])
		end = float(tierLines[3].strip().split(" = ")[1])

		tierType = ""
		
		if "points" in tierLines[4]:
			tierType = "point"
			points = re.split(r'points \[[0-9]*\]', raw)[1:]
			tier = Tier(name, start, end, tierType)
			self.loadAnnotations(tier, points)
		else:
			tierType = "interval"
			intervals = re.split(r'intervals \[[0-9]*\]', raw)[1:]
			tier = Tier(name, start, end, tierType)
			self.loadAnnotations(tier,intervals)

		self.tiers.addTier(name, tier)

	def loadAnnotations(self, tier, annotationList):
		for ann in annotationList:
			annLines = ann.strip().split("\n")[1:]
			end = None
			features = None
			start = float(annLines[0].strip().split(" = ")[1])

			#point
			if len(annLines) == 2:
				end = start
				features = annLines[1].strip().split("mark = ")[1]

			#interval
			elif len(annLines) == 3:
				end = float(annLines[1].strip().split(" = ")[1])
				features = annLines[2].strip().split("text = ")[1]

			iAnn = Annotation(start, end, features)
			tier.addAnnotation(iAnn)

	def getAnnotations(self, tier, start, end):
		return self.tiers.getAnnotations(tier, start, end)

	def getTier(self, name):
		return self.tiers.getTier(name)

	def writeTextGrid(self, path):
		tiers = ["tones","breaks"]
		length = len(tiers)
		new_txg = self.getOutputHeadline(length)
		tiers_out = self.getOutputTiers(tiers) 		
		new_txg = new_txg+ "\n"+ tiers_out

		result = open(path, "w")
		result.write(new_txg)
		result.close()

	def getOutputHeadline(self, length):
		lines = self.lines
		#check if this is possible or extract lines from textgrid
		headline = lines[:6]
		tot_n_tiers = str(length)
		size_line = lines[6].split("=")[0] + " = "+ tot_n_tiers
		headline.append(size_line)
		headline.append(lines[7])
		strHead = "\n".join(headline)
		return strHead

	def getOutputTiers(self, selectedTiers = []):
		## Creo que falta una función para llamar a todos los tiers y que estén numerados
		tiers = self.tiers.getAllTiers(selectedTiers)
		new_tiers = ""

		for ix,tier in enumerate(tiers):
			n_tier = ix +1

			classStr = ""
			if tier.type == "point":
				classStr = "\"TextTier\""
			else:
				classStr = "\"IntervalTier\""

			new_tiers += self.tab+"item ["+ str(n_tier) +"]:"+"\n"
			new_tiers += self.tab+self.tab+"class = "+ classStr +"\n"
			new_tiers += self.tab+self.tab+"name = \""+ tier.name + "\"" +"\n"
			new_tiers += self.tab+self.tab+"xmin = 0 " +"\n"
			new_tiers += self.tab+self.tab+"xmax = "+ str(tier.xmax) +"\n"

			write_ann = self.getOutputAnnotations(tier)
			new_tiers += write_ann

		return new_tiers

	def getOutputAnnotations(self, tier):
		typeOfTier = str(tier.type)

		new_annot = ""
		if typeOfTier == "point":
			annotations = tier.annotations
			size = len(annotations)
			new_annot += self.tab+self.tab+"points: size = " + str(size) + "\n"

			for idx, ann in enumerate(annotations) :
				new_annot += self.tab+self.tab+"points [" + str(idx+1) +"]:" +"\n"
				new_annot += self.tab+self.tab+self.tab+"number = " + str(ann.xmin)+"\n"
				new_annot += self.tab+self.tab+self.tab+"mark = \""+ str(ann.text) + "\""+"\n"

		elif typeOfTier == "interval":
			annotations = tier.annotations
			size = len(annotations) + 1
			new_annot += self.tab+self.tab+"intervals: size = " + str(size) + "\n"

			for idx, ann in enumerate(annotations) :
				new_annot += self.tab+self.tab+"intervals [" + str(idx+1) +"]:" +"\n"
				new_annot += self.tab+self.tab+self.tab+"xmin = " + str(ann.xmin)+"\n"
				new_annot += self.tab+self.tab+self.tab+"xmax = " + str(ann.xmax)+"\n"
				new_annot += self.tab+self.tab+self.tab+"text = \""+ str(ann.text) + "\""+"\n"			
			
		return new_annot

class Tiers():

	def __init__(self, start, end):
		self.tiers = {}
		self.xmin = start
		self.xmax = end
		self.size = 0
		self.keyOrder = []

	def addTier(self, name, tier):
		self.tiers[name] = tier
		self.keyOrder.append(name)
		self.size +=1

	def getTier(self, name):
		return self.tiers[name]

	def getAnnotations(self, targetTier, start, end):
		return self.tiers[targetTier].getAnnotations(start, end)

	def getAllTiers(self, selectedTiers=[]):
		tierList = []
		if selectedTiers:
			for key in self.keyOrder:
				if key in selectedTiers:
					elem = self.tiers[key]
					tierList.append(elem)
		else:
			for key in self.keyOrder:
				elem = self.tiers[key]
				tierList.append(elem)

		return tierList

	def __len__(self):
		return len(self.tiers.keys())



class Tier():

	def __init__(self, name, start, end, tierType):	
		self.xmin = start
		self.xmax = end
		self.name = name
		self.type = tierType
		self.size = 0
		self.annotations = []

	def addAnnotation(self, annotation):
		self.annotations.append(annotation)
		self.size +=1

	def getAnnotations(self, start, end):
		anns = []

		for annotation in self.annotations:
			if annotation.xmin >= start and annotation.xmax <= end:
				anns.append(annotation)

		return anns

class Annotation():

	def __init__(self, start, end, rawFeatures=None, head=None, features=None):
		self.xmin = start
		self.xmax = end
		if features:
			self.text = Text(features=features, head=head)
		else:
			self.text = Text(rawFeatures=rawFeatures)

		self.head = self.text.head


	def getFeature(self, featureName):
		return self.text.getFeature(featureName)

	def addFeature(self, key, value):
		self.text.addFeature(key, value)

	def __str__(self):
		if self.head:
			return "Start:"+str(self.xmin)+ " End:"+str(self.xmax)+ " HEAD:"+ str(self.head) + "\nFEATURES\n"+str(self.text.features)+"\n"
		else:
			return "Start:"+str(self.xmin)+ " End:"+str(self.xmax)+ " HEAD: No Head" + "\nFEATURES\n"+str(self.text.features) + "\n"
	
	def __repr__(self):
		if self.head:
			return "Start:"+str(self.xmin)+ " End:"+str(self.xmax)+ " HEAD:"+ str(self.head) + "\nFEATURES\n"+str(self.text.features)+"\n"
		else:
			return "Start:"+str(self.xmin)+ " End:"+str(self.xmax)+ " HEAD: No Head" + "\nFEATURES\n"+str(self.text.features) + "\n"

class Text():

	def __init__(self, rawFeatures=None, features=None, head=None):
		self.features = {}
		self.head = None
		if features:
			self.features = features

		if head:
			self.head = head

		if rawFeatures:
			self.rawFeatures = rawFeatures
			self.extractText()

	def extractText(self):
		if self.rawFeatures == '""':
			pass
		
		elif "{" not in self.rawFeatures:
			self.head = self.rawFeatures.replace('"',"")
		
		else:
			cleanFeats = self.rawFeatures.replace('"',"")
			cleanFeats = cleanFeats.replace("}","")
			cleanFeats = cleanFeats.replace(" ","")
			pieces = cleanFeats.split("{")
			if pieces[0] != '"':
				self.head = pieces[0].replace('"',"")
			
			pieces = pieces[1].split(",")
			
			for feat in pieces:
				key, value = feat.split("=")
				self.features[key] = value

	def getFeature(self, feature):
		result = None
		if feature in self.features.keys():
			result = self.features[feature]
		
		return result

	def addFeature(self, key, value):
		self.features[key] = value
			
	def __str__(self):
		strText = ""
		head = self.head
		if head:
			strText+=str(head)

		if self.features:
			strText+="{"
			for key, value in self.features.items():
				strText+=key+"="+str(value)+","

			strText = strText[:-1]
			strText+="}"	

		return strText 

	def __repr__(self):
		strText = ""
		head = self.head
		if head:
			strText+=head

		if self.features:
			strText+="{"
			for key, value in self.features.items():
				strText+=key+"="+value+","
				
			strText = strText[:-1]
			strText+="}"	

		return strText
if __name__ == '__main__':

	iT = TextGrid("sample.TextGrid")

	#get me the IP annotations from 0 to 5.5
	print(iT.getAnnotations("IP",0,5.5))
	anns = iT.getAnnotations("IP",0,5.5)

	#get me the phone_mean of each found annotation
	for ann in anns:
		print(ann.getFeature("phone_mean"))