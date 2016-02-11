data = 
	cards: [
		id: 1
		name: 'Freunde'
		myVote: 0
	,
		id: 2
		name: 'Bundestag'
		myVote: 0
	,
		id: 3
		name: '#BuPrä'
		myVote: 0
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
		myVote: 0
	,
		id: 5
		name: 'Mein Verein'
		myVote: 0
	,
		id: 5
		name: 'Mein Verein'
		myVote: 0
	,
		id: 5
		name: 'Mein Verein'
		myVote: 0
	,
		id: 5
		name: 'Mein Verein'
		myVote: 0
	,
		id: 5
		name: 'Mein Verein'
		myVote: 0
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
	backgroundColor: 'yellow'
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
	backgroundColor: 'yellow'
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
		
# 		closestContentLayer(event.offsetX *  1 / zoomcontainer.scale,event.offsetX * 1/≈ )

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
 

render = (currentCard) ->
	
# 	for card in scrollcontainer.children
# 		print card
# 		card.destroy()
	
	zoomcontainer.scale = 0.05	
	zoomcontainer.animate
    	properties:
    	    scale: 1
    	    #rotation: 90
   	 time: 1
    
	i = 0
	cards = []
	for data in currentCard.cards
	
		cards.push new Layer
			name: data.name
			cards: if data.cards then data.cards else []
			parent: scrollcontainer.content
			html: "<br>&nbsp;&nbsp;#{data.name} (#{if data.cards then data.cards.length else '0'}) ||| #{data.myVote}"
			x:  i * 650 #125
			y: 0 #250
			width: 600 #100
			height: 1000 #150
			borderRadius: 20
			backgroundColor: "#28affa"		
# 		cards[i].states.add
# 			big:
# 				scale: 2
# 				x: ( i * 250) * 2
# 			small:
# 				scale: 1
# 				x: ( i * 250) 
# 		cards[i].states.animationOptions =
# 		    curve: "spring(100, 10, 0)"
		
		cards[i].draggable.horizontal = false
		cards[i].draggable.vertical = true	
		
		# Drag in increments of 20px 
		cards[i].draggable.updatePosition = (point) ->
		    point.y = round(point.y, 1050)
		    return point

		
		#cards[i].on Events.Click, (event, layer) ->
			#cardContainer.scale = 2
# 			for c in cards
# 				c.states.switch("big")
			#zoomcontainer.zoomcontainerToLayer(layer)
	
		cards[i].onPinch ->
			zoomcontainer.center()
		cards[i].onPinchStart ->
			if zoomcontainer.scale == 1
				zoomcontainer.pinchable.enabled = false
		
		cards[i].onPinchEnd ->
			#print this
			if zoomcontainer.scale == 1
				zoomcontainer.pinchable.enabled = true
				#print cards[i]

			
		
		cards[i].on Events.DragStart, (event, draggable, layer) ->
			scrollcontainer.scrollVertical = false
		
	
		cards[i].on Events.DragEnd, (event, draggable, layer) ->


			change = (draggable.layerStartPoint.y - draggable.offset.y) / 1050
			#print change
			
			#layer.myVote = cards[i].myVote + change
			#layer.html = cards[i].myVote
			
			scrollcontainer.updateContent()
			if layer.y < 145
				scrollcontainer.scrollVertical = true
				if layer.y < -185
					#moveUp(layer,2)
				else
					#moveUp(layer)
			else
				if layer.y > 824
					scrollcontainer.scrollVertical = true
					if layer.y > 1175
						#moveDown(layer,2)
					else
						#moveDown(layer)			
				else
					layer.animate
						properties:
							y: 500
						time: 0.2
					
					
		i = i + 1

render(currentCard)

# zoomcontainer.on Events.zoomcontainerEnd, (event, draggable, layer) ->
# 	zoom()
# 
# zoomcontainer.on Events.Click, (event, layer) ->
# 	zoom()
	

# titleBar.on Events.Click, (event,layer) ->
# 	zoomOut()

zoomOut = ->
	for c in cards
		c.states.switch("small")
	zoomcontainer.zoomcontainerToLayer(layer)	

moveUp = (movedCard) ->
	movedCard.myVote = movedCard.myVote + 1


move = (moved) ->
	next_x = -300
	for card in cards	
		unless card == moved
			next_x = next_x + 500		
			card.animate
				properties:
					x: next_x
				time: 0.1
		#print "#{card.name}: #{card.x} #{card.y}"
		
	zoomcontainer.zoomcontainerToPoint(
	    x: zoomcontainer.zoomcontainerX + 800
	    true
	    curve: "ease"
	    time: 10
	)
 


