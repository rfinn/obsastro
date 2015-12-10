procedure align(reference,images,outimage)

string reference {prompt="reference image"}
string images {prompt="images/image list (@) to be aligned"}
string outimage {prompt="final,co-added image"}

struct *inl

begin
  
     real xref,yref,xin,yin,xshift,yshift,x,y
     string  ref,im,out,c1,list1,list2,current,outlist
     int i
     bool dummy
#    -------------------------------------

     ref=reference
     im=images
     out = outimage
#    delete temporary files, if they exist
#    --------------------------------------
     if (access ('shifts')) { del ('shifts') }
     if (access ('trashbin')) { del ('trashbin') }
     if (access ('shiftedlist')){imdelete('@shiftedlist')}
     if (access ('shiftedlist')) { del ('shiftedlist') }
     if (access ('pos')) 
	{ del ('pos') 
	  print ("deleted")} 
     else
	print("abc")
     if (access ('outlist')) { del ('outlist') }
#    display the reference image and get the coordinates
#    ---------------------------------------------------
     print('---------------------------------------')
     print('Displaying the reference image..')
     print('Mark (all) stars for shift calculation')
     print('Exit with CTRL D')
     print('---------------------------------------')
     display(ref,1,>'trashbin')
     rimcur(ref,wcs="logical",>'pos') 

#    expand the input template
#    --------------------------
      if (access("tmplst")) { delete("tmplst",v-) }
      i=strlen(im)
      c1 = substr(im,1,1)
#     template or @-list?
#     --------------------
#
      if (c1 == "@") { 
	  copy(substr(im,2,i),"tmplst",v-) 
	}
       else {
          section(im, option="fullname") | sort(> "tmplst")
      }
#     Note: now "tmplst" has the list of files to be aligned 

#     read in the firs coordinates as references for initial shifts
#     ------------------------------------------------------------
      inl = "pos"
      if(fscan(inl,xref,yref)==EOF){}
      print('---------------------------------------')
      print('Displaying the images to be aligned ')
      print('Mark the source that was at ',xref,yref,' in the reference, only!')
      print('Exit with CTRL D')
      print('---------------------------------------')

      inl = "tmplst"

#     Read the aperture list and extract the spectra
#     ----------------------------------------------
      while (fscan(inl,current) != EOF) {
      display(current,2,>>'trashbin')
      if(access("temp")){delete("temp")}
      rimcur(current,wcs="logical") | scan(xin,yin)
      xshift=xref-xin
      yshift=yref-yin
      print(xshift,yshift,>>"shifts")
      print('Estimate of the shift ',xshift,yshift)

      print("r"//current,>>"outlist")
#     this is the output list for the next task "imalign"

       }

#------------
#       align the images......
	imalign(im,ref,'pos',"@outlist",shifts='shifts')
        files("@outlist",>'shiftedlist')

#       and co-add the aligned images...
	#( change the following parameters according to the
	# application)
	imcombine('@shiftedlist',out,combine='average',
	   scale='none',zero='mode',reject='ccdclip',
	   mclip+,nkeep=1,nlow=2,nhigh=0,lsigma=3,hsigma=3,
	   statsec='[400:600,400:600]',rdnoise='rdnoise',gain=2160.)
#       clean up .....
#rf        imdelete('@shiftedlist',v-)

end






