class CSSBox


	constructor:(width, height,depth,scene)->

		@position = THREE.Vector3( 0, 0, 0 )
		@rotation = THREE.Vector3( 0, 0, 0 )

		@setup = [
			{
				position: new THREE.Vector3 -width/2, 0, 0 
				rotation: new THREE.Vector3 0, Math.PI / 2, 0 
				color: new THREE.Color( 0x333333 ).getStyle()
				width: depth
				height: height
			},
			{
				position: new THREE.Vector3 width/2, 0, 0 
				rotation: new THREE.Vector3 0, -Math.PI / 2, 0 
				color: new THREE.Color( 0x888888 ).getStyle()
				width: depth
				height: height
			},
			{
				position: new THREE.Vector3 0, height/2, 0 
				rotation: new THREE.Vector3 Math.PI / 2, 0, Math.PI 
				color: new THREE.Color( 0x555555 ).getStyle()
				width: width
				height: depth
			},
			{
				position: new THREE.Vector3 0, -height/2, 0 
				rotation: new THREE.Vector3 -Math.PI / 2, 0, Math.PI 
				color: new THREE.Color( 0x666666 ).getStyle()
				width: width
				height: depth
			},
			{
				position: new THREE.Vector3 0, 0,  depth/2 
				rotation: new THREE.Vector3 0, Math.PI, 0 
				color: new THREE.Color( 0x777777 ).getStyle()
				width: width
				height: height
			},
			{
				position: new THREE.Vector3 0, 0, -depth /2
				rotation: new THREE.Vector3 0, 0, 0 
				color: new THREE.Color( 0x444444 ).getStyle()
				width: width
				height: height
			}
		]

		@materials = []
		@faces = []

		for i in [0...6] by 1
			s = @setup[i]
			material = document.createElement( 'div' )
			material.style.width = s.width+'px'
			material.style.height = s.height+'px'
			material.style.background = s.color
			@materials.push(material)
			face = new THREE.CSS3DObject( @materials[i] )
			face.rotation = s.rotation
			face.position = s.position
			@faces[i] = face

		if scene != undefined
			@attach scene

		return


	attach:(scene)->
		for i in [0...6] by 1
			scene.add @faces[i]

		return
	
	detach:(scene)->
		for i in [0...6] by 1
			scene.remove @faces[i]
		return


	explode:(instant=false, radius=3000)->
		
		for i in [0...6] by 1

			f = @faces[i]
			s = @setup[i]
			v = new THREE.Vector3( 0, 0, 0 )
			v.add(s.position)
			v.add(@position)
			yOffset = Math.sin(s.rotation.x)*radius
			xOffset = -Math.sin(s.rotation.y)*radius
			v.y += yOffset
			v.x += xOffset

			if i == 5
				v.z += -Math.cos(s.rotation.x)*radius
			if i == 4
				v.z += Math.cos(s.rotation.x)*radius

			if instant
				# f.rotation = s.rotation #v.add(@setup[i].rotation, @rotation)
				f.position = v

			else 
				# TweenLite.to(f.rotation,
				# 	x:s.rotation.x
				# 	y:s.rotation.y
				# 	z:s.rotation.z
				# 	delay : Math.random()*500
				# 	ease : Sine.easeOut
				# )

				TweenLite.to(f.position, 1.5
					x		: v.x
					y		: v.y
					z		: v.z
					ease 	: Quad.easeOut
					delay	: 1.3*Math.random()
				)

		return


	recompose:()->

		for i in [0...6] by 1

			f = @faces[i]
			s = @setup[i]
			
			# TweenLite.to(f.rotation,
			# 	x:s.rotation.x
			# 	y:s.rotation.y
			# 	z:s.rotation.z
			# 	delay : Math.random()*500
			# 	ease : Sine.easeOut
			# )

			v = new THREE.Vector3( 0, 0, 0 )
			v.add(s.position)
			v.add(@position)

			TweenLite.to(f.position, .5
				x 		:v.x
				y 		:v.y
				z		:v.z
				delay	: Math.random()*1.3
				ease 	: Quad.easeOut
			)

		return


	setPosition:(pos)->
		@position = pos
		for i in [0...6] by 1
			f = @faces[i]
			s = @setup[i]
			v = new THREE.Vector3( 0, 0, 0 )
			v.add(s.position)
			v.add(@position)
			f.rotation = s.rotation #v.add(@setup[i].rotation, @rotation)
			f.position = v

		return


		