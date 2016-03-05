data = 
	cards: [
		id: 1
		name: 'Freunde'
		myVote: 2
	,
		id: 2
		name: 'Bundestag'
		myVote: 2
	,
		id: 3
		name: '#BuPrä'
		myVote: 2
		title: 'Bundespräsident*innenwahl 2016'
		description: 'Ranke deine Favoriten'
		cards: [
			id: 6
			name: 'Michael Bohmeyer'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false
		,	
			id: 7
			name: 'Johannes Ponader'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false
		,	
			id: 8
			name: 'Amira Jehia'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false
		,	
			id: 9
			name: 'Helene Fischer'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false	
		,	
			id: 10
			name: 'Helene Fischer2'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false			
		,	
			id: 11
			name: 'Helene Fischer3'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false
		,				
			id: 12
			name: 'Helene Fischer4'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false
		,					
			id: 13
			name: 'Helene Fischer5'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false
		,			
			id: 14
			name: 'Helene Fischer6'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false
		,			
			id: 15
			name: 'Helene Fischer7'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false
		,				
			id: 16
			name: 'Helene Fischer8'
			teaser: 'Mensch'
			myVote: 0
			allVotes: 0
			seen: false
				
		]
	,
		id: 4
		name: 'Meine Arbeit'
		myVote: 2
	,
		id: 5
		name: 'Mein Verein'
		myVote: 2
	,
		id: 5
		name: 'Mein Verein'
		myVote: 2
	,
		id: 5
		name: 'Mein Verein'
		myVote: 2
	,
		id: 5
		name: 'Mein Verein'
		myVote: 2
	,
		id: 5
		name: 'Mein Verein'
		myVote: 2
	]


################################################
### Init #######################################
################################################

#currentScope = false
currentCard = data
zoomLevel = 0



zoomcontainer = new ScrollComponent
	height: Screen.height 
	width: Screen.width 
	backgroundColor: 'lightcyan'
zoomcontainer.scrollHorizontal = false
zoomcontainer.scrollVertical = false
zoomcontainer.pinchable.enabled = true
zoomcontainer.pinchable.rotate = false
zoomcontainer.pinchable.minScale = 0.0
zoomcontainer.pinchable.maxScale = 1
zoomcontainer.pinchable.centerOrigin = false
zoomcontainer.pinchable.scaleIncrements = 0.01

zoomcontainer.center()
	
scrollcontainer = new ScrollComponent
	height: Screen.height
	width: Screen.width
	parent: zoomcontainer.content 
	backgroundColor: 'lightcyan'
	scrollHorizontal: true
	scrollVertical: false
scrollcontainer.contentInset =
    top: 100
    right: 100
    bottom: 100
    left: 50

scrollcontainer.center()



scrollcontainer.on Events.DoubleTap, (event) ->
		
	if zoomcontainer.scale < 1
		zoomcontainer.scale = 1
	else
		zoomcontainer.scale = 0.25
	
	scrollcontainer.width = zoomcontainer.width = Screen.width * (1 / zoomcontainer.scale)
	scrollcontainer.height = zoomcontainer.height = Screen.height * (1 / zoomcontainer.scale)
	
	#scrollcontainer.center()
	zoomcontainer.center()
	
	if zoomcontainer.scale == 1
		scrollcontainer.y = 0 
		closest_card = scrollcontainer.closestContentLayerForScrollPoint(
   			x: event.offsetX * zoomcontainer.scale
   			y: event.offsetY * zoomcontainer.scale
		)

		scrollcontainer.scrollToLayer(
 		   closest_card
    		0.5, 0.5
    		false
		)
	

	

zoomcontainer.onPinch ->
	scrollcontainer.width = zoomcontainer.width = Screen.width * (1 / zoomcontainer.scale)
	scrollcontainer.height = zoomcontainer.height = Screen.height * (1 / zoomcontainer.scale)
	zoomcontainer.center()
	scrollcontainer.center()
	
	

zoomcontainer.onPinchStart ->
	scrollcontainer.scrollHorizontal = false
	scrollcontainer.scrollVertical = false	
	if currentCard.cards
		for card in currentCard.cards
			card.draggable.vertical = false

zoomcontainer.onPinchEnd ->
	
	scrollcontainer.scrollHorizontal = true
	scrollcontainer.scrollVertical = true unless zoomcontainer.scale == 1
	
	if currentCard.cards
		for card in currentCard.cards
			card.draggable.vertical = true
	
	
	


background = new BackgroundLayer
	backgroundColor: 'white'

# titleBar = new Layer
# 	x:0
# 	y:0
# 	height: 100
# 	width: 1000	
# 	html: if currentCard then currentCard.name else ''

cardSizes = 
	L:
		width: 450
		height: 600
		x: 150
	M:
		width: 200
		height: 300
		x: 50
		y: 500
		upLimit: 145
		doubleUpLimit: -185
		downLimit: 825
		doubleUpLimit: 1175
		

################################################
### Prepare Cards ##############################
################################################

round = (number, nearest) ->
    Math.round(number / nearest) * nearest
 
 
 
rearrange = (currentCard, currentMove = false) ->
	
	level = []

	for card in scrollcontainer.content.children
		level[card.level] = {} unless level[card.level]
# 		level[card.level].min = card.x if !level[card.level].min || card.x < level[card.level].min
# 		level[card.level].max = card.x if !level[card.level].max || card.x > level[card.level].max
		level[card.level].cards = [] unless level[card.level].cards
		level[card.level].cards.push card

	for obj in level
		i = 0 
		if obj
			for card in obj.cards	
				
# 				if currentMove
# 					print currentMove.x
# 					i = i + 1
# 					alert 'jaaaaaaa'
				
				
				card.animate 
					properties:
						x: 650 * i
						#backgroundColor: if i == 2 then 'blue' else if i < 2 then 'green' else 'red'
					time: 0.1
				i=i+1
		

render = (currentCard) ->
	
# 	for card in scrollcontainer.children
# 		print card
# 		card.destroy()
	
	i = 0
	cards = []
	rendered_cards = []
	for data in currentCard.cards
		
		colors = ['slateblue','skyblue','royalblue','powderblue','darkturquoise','navy','midnightblue','mediumblue','dodgeblue']

		
		test = new Layer
			name: data.name
			cards: if data.cards then data.cards else []
			parent: scrollcontainer.content
			html: "<br>&nbsp;&nbsp;#{data.name} (#{if data.cards then data.cards.length else '0'}) ||| #{data.myVote}"
			x:  i * 650 #125
			y: 2100 #250
			z: 10
			width: 600 #100
			height: 1000 #150
			borderRadius: 20
			backgroundColor: colors[i]	
			
		rendered_cards.push test
		
		
		
		do(test) ->
		
			test.level = data.myVote
			
			test.draggable.horizontal = false
			test.draggable.vertical = true	
			
			# Drag in increments of 20px 
# 			test.draggable.updatePosition = (point) ->
# 			    point.y = round(point.y, 1050)
# 			    return point
		
# 			test.onPinch ->
# 				zoomcontainer.center()
# 			test.onPinchStart ->
# 				if zoomcontainer.scale == 1
# 					zoomcontainer.pinchable.enabled = false
# 			
# 			test.onPinchEnd ->
# 				#print this
# 				if zoomcontainer.scale == 1
# 					zoomcontainer.pinchable.enabled = true
# 					#print cards[i]
			
			test.on Events.DragEnd, (event, draggable, layer) ->
						
				#rearrange(currentCard)
				
				layer.animate
					properties:
						y: test.level * 1050
					time: 0.1		

				#print change
				test.startY = null
				
			
			test.on Events.DragStart, (event, draggable, layer) ->
				
				scrollcontainer.scrollVertical = false
				#scrollcontainer.scrollHorizontal = false
				test.startY = layer.y
				
			test.on Events.DragMove, (event, draggable, layer) ->
				
				test.level = Math.round(layer.y / 1050)
				
				if Math.round(test.startY - layer.y) / 1050 > 0
					test.startY = 1050 * Math.round(test.startY - layer.y)
					rearrange(currentCard, layer)
						
						
			
				
				
		i = i + 1
	

	
# 	scrollcontainer.scrollToLayer(
# 		rendered_cards[0]
# 		0.5, 0.5
# 		true
# 	)




render(currentCard)

Utils.interval 1, ->
	for card in scrollcontainer.content.children
		card.animate
			properties:
				y: card.level * 1050
			time: 0.1	
	

layerA = new Layer
layerA.backgroundColor = 'lightgreen'
layerA.height=2275
layerA.width = 10000
layerA.x = -200
layerA.y = -200
layerA.parent = scrollcontainer.content

layerB = new Layer
layerB.backgroundColor = 'lightpink'
layerB.y = 3130
layerB.x = -200
layerB.height=10000
layerB.width = 10000
layerB.parent = scrollcontainer.content




# zoomcontainer.on Events.zoomcontainerEnd, (event, draggable, layer) ->
# 	zoom()
# 
# zoomcontainer.on Events.Click, (event, layer) ->
# 	zoom()
	
 


