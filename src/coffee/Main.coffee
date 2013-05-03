#Global var
camera 		= null
scene 		= null
renderer 	= null
controls 	= null

boxs 		= []
state 		= "construct"

init = ( )->

	camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, 1000 )
	camera.position.set( 0, 1000, 1000 )

	controls = new THREE.TrackballControls( camera )

	controls.rotateSpeed = 1.0
	controls.zoomSpeed = 1.0
	controls.panSpeed = 0.8

	controls.noZoom = false
	controls.noPan = false

	controls.staticMoving = false
	controls.dynamicDampingFactor = 0.3

	scene = new THREE.Scene()

	for i in [-1..1] by 1
		for j in [-1..1] by 1
			if i == 0 and j == 0
				createDungeon(0,0,0)

			else if i == 0
				wall = new CSSBox 50, 150, 660, scene
				wall.setPosition(new THREE.Vector3( j*400, -75, 0 ) )
				boxs.push(wall)

			else if j == 0 
				wall = new CSSBox 660, 150, 50, scene
				wall.setPosition(new THREE.Vector3( 0, -75, i*400 ) )
				boxs.push(wall)
			else
				createTower(i*400,0,j*400)

	renderer = new THREE.CSS3DRenderer()
	renderer.setSize( window.innerWidth, window.innerHeight )
	renderer.domElement.style.position = 'absolute'
	renderer.domElement.style.top = 0
	renderer.domElement.style.left = 0
	document.body.appendChild( renderer.domElement )

	window.addEventListener 'click', onClick


onClick = (e)->

	console.log "click"

	e.preventDefault()
	if state == "construct"
		for box in boxs
			box.explode()
		state = "explode"
	else
		for box in boxs
			box.recompose()
		state = "construct"

createDungeon = (x,y,z)->



createWall = (x,y,z)->



createTower = (x,y,z)->
	# Create Tower
	base = new CSSBox 140, 300, 140, scene
	base.setPosition( new THREE.Vector3( x, y, z ) )
	boxs.push(base)

	plateform = new CSSBox 200, 50, 200, scene          
	plateform.setPosition(new THREE.Vector3(x, y+175, z) )
	boxs.push(plateform)

	for i in [-1..1] by 1
		for j in [-1..1] by 1
			if i == 0 && j==0 then continue
			creneau = new CSSBox 40,40,40,scene
			creneau.setPosition(new THREE.Vector3( x+i*80, y+220, z+j*80))
			boxs.push(creneau)


animate = ()->

	requestAnimationFrame( animate )
	controls.update()
	renderer.render( scene, camera )


init()
animate()