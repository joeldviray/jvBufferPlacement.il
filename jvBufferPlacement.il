procedure( jvPlaceInstanceToPinLocation()

	command="jvPlaceInstanceToPinLocation"
	jvLog()

	cv=geGetEditCellView()
	selected=geGetSelSet()
	geDeselectAll()

	foreach(cell selected
		;;if(cell~>cellName=="edgebuf_unit" then
			;cellOrigin=cell~>xy
			;cellNet=car(cell~>conns~>net~>name)
			cellNet=nth(3 cell~>conns~>net~>name)

			foreach(pin cv~>shapes
				
					if(pin~>purpose=="pin"&&pin~>net~>name==cellNet then
					pinOrigin=car(pin~>bBox)
					geSelectFig(pin)
					);if
				
			)	
			cell~>xy=pinOrigin		

		;;);if

	);foreach
	geDeselectAll()
	geSelectFigs(selected)
)

procedure( jvAbout2() ;jvSelectInstanceByPin()

	cv=geGetEditCellView()

	foreach(cell cv~>instances
		cellNet=cell~>conns~>net~>name
		cellX=caar(cell~>xy)
		cellY=
		
		if(rexMatchList(car(geGetSelSet()~>net~>name) cellNet) then
			geSelectFig(cell)
			;printf("test")
			
		)
		
	);foreach

);procedure

procedure( jvSelectInstanceByPin() ;ver2 for selecting pin and selects the instance correspondence - its working

	;jvListNets()


	command="jvSelectInstanceByPin"
	jvLog()



	foreach(pin geGetSelSet()
		foreach(cell geGetEditCellView()~>instances
			cellNet=cell~>conns~>net~>name
			if(rexMatchList(pin~>net~>name cellNet) then
			geSelectFig(cell)
			;cell~>conns~>net~>name	
			);if
		);foreach
	);foreach

	jvListNets()


);procedure

procedure( jvAbout4() ;jvFlipHorizontal()

	;Need to load these first..
	;load("/home/jviray/.skill_jv/jvTool/abFlip.il")
	;load("/home/jviray/.skill_jv/jvTool/abZoomSel.il")

	;foreach(inst geGetSelSet()
		abFlip()
		;printf("test")
	;);foreach	

);

hiSetBindKey("Layout" "Ctrl<key>q" "jvAbout4()")

procedure( unknown_CCSDisableStrokes() ;jvFlipHorizontal() ;ver2 - its working

	;Need to load these first..
	;load("/home/jviray/.skill_jv/jvTool/abFlip.il")
	;load("/home/jviray/.skill_jv/jvTool/abZoomSel.il")


	selected=geGetSelSet()
	geDeselectAll()

	foreach(selected1 selected
		geSelectFig(selected1)
		abFlip()
		geDeselectFig(selected1)
	);foreach

)

procedure( jvListNets()

	command="jvListNets"
	jvLog()


	printf("%L" geGetSelSet()~>conns~>net~>name)


)
procedure(option1()
	printf("Success")	
);procedure

procedure(option2()
	printf("NotSuccess")	
);procedure

procedure(option3()
	printf("Selected Nothing")	
);procedure



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;for place instance to pin
procedure(jvMenuPlaceInstanceToPin()

	command="jvMenuPlaceInstanceToPin"
	jvLog()



IntField = hiCreateIntField(

	?name    'IntField
	?prompt    "net position (eg. 0,1,2..)"
	?value    0
	?defValue  0

)

Button = hiCreateButton(
	?name	'checkNet
	?buttonText	"Check nets"
	?callback "jvListNets()"


)



jvFormPlaceInstanceToPin=hiCreateAppForm(
	?name gensym('jvFormSelectInstanceToPin)
	?formTitle "Place Instance To Pin"
	?fields list( Button IntField)
	;?buttonLayout `OKCancelApply
	?initialSize list(1 100)
	?callback "jvPlaceInstanceToPin()"
)
hiDisplayForm(jvFormPlaceInstanceToPin)
)
;jvMenuSelectInstanceToPin()



procedure( jvPlaceInstanceToPin()


	command="jvPlaceInstanceToPin"
	jvLog()


	cv=geGetEditCellView()
	selected=geGetSelSet()
	geDeselectAll()

	foreach(cell selected
			cellNet=nth(jvFormPlaceInstanceToPin->IntField->value cell~>conns~>net~>name)

			foreach(pin cv~>shapes
				
					if(pin~>purpose=="pin"&&pin~>net~>name==cellNet then
					pinOrigin=car(pin~>bBox)
					geSelectFig(pin)
					);if
				
			)	
			cell~>xy=pinOrigin		

		;;);if

	);foreach
	geDeselectAll()
	geSelectFigs(selected)

	selected~>conns~>net~>name

)

procedure( jvLog()

x=geGetEditCellView()
;command="test"
time=getCurrentTime()
;pwd
library=x~>libName
cell=x~>cellName
view=x~>viewName

procedure( jvWhoAmI()
system("whoami > myName")
      let(( inPort nextLine)
        inPort = infile( "./myName")
        when( inPort
          while( gets( nextLine inPort)
         printf("%s" nextLine)

	 myName=nextLine	

          )
      close( inPort)
          )
         )
     )

procedure( jvPwd()
system("pwd > myPath")
      let(( inPort nextLine)
        inPort = infile( "./myPath")
        when( inPort
          while( gets( nextLine inPort)
         printf("%s" nextLine)

	 myPath=nextLine	

          )
      close( inPort)
          )
         )
     )
jvWhoAmI()
jvPwd()


newChar=pcreCompile("\n")
colon=pcreCompile(":")
space=pcreCompile(" ")
myName=pcreReplace(newChar myName "" 0) ;remove the newChar
myPath=pcreReplace(newChar myPath "" 0) ;remove the newChar
myTime=pcreReplace(colon time "" 0) ;remove the colon in time
myTime2=pcreReplace(space myTime "" 0) ;remove the spaces in time

myFile = strcat(command "_" myTime2 "_" myName)
myPort = outfile(strcat("/home/jviray/tmp/" myFile))
fprintf(myPort strcat(myName "\n"))
fprintf(myPort strcat(myPath "\n"))
fprintf(myPort strcat(time "\n"))
fprintf(myPort strcat(library "\n"))
fprintf(myPort strcat(cell "\n"))
fprintf(myPort strcat(view "\n"))
close(myPort)

)
