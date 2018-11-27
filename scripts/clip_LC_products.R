####################################################################################################
####################################################################################################
## Clip available products
## Contact remi.dannunzio@fao.org 
## 2018/05/04
####################################################################################################
####################################################################################################

time_start  <- Sys.time()

####################################################################################
####### GET COUNTRY BOUNDARIES
####################################################################################
aoi <- getData('GADM',path=paste0(rootdir,"/data/gadm/"), country= the_country, level=1)
bb <- extent(aoi)


#################### CREATE GFC TREE COVER MAP in 2000 AT THRESHOLD
system(sprintf("gdal_calc.py -A %s --co COMPRESS=LZW --outfile=%s --calc=\"%s\"",
               paste0(gfc_dir,"gfc_treecover2000.tif"),
               gfc_tc,
               paste0("(A>",gfc_threshold,")*A")
))

#################### CREATE GFC TREE COVER LOSS MAP AT THRESHOLD
system(sprintf("gdal_calc.py -A %s -B %s --co COMPRESS=LZW --outfile=%s --calc=\"%s\"",
               paste0(gfc_dir,"gfc_treecover2000.tif"),
               paste0(gfc_dir,"gfc_lossyear.tif"),
               gfc_ly,
               paste0("(A>",gfc_threshold,")*B")
))

#################### CREATE GFC FOREST MASK IN 2000 AT THRESHOLD (0 no forest, 1 forest)
system(sprintf("gdal_calc.py -A %s --co COMPRESS=LZW --outfile=%s --calc=\"%s\"",
               gfc_tc,
               gfc_00,
               "A>0"
))

#################### CREATE GFC FOREST MASK IN 2016 AT THRESHOLD (0 no forest, 1 forest)
system(sprintf("gdal_calc.py -A %s -B %s -C %s --co COMPRESS=LZW --outfile=%s --calc=\"%s\"",
               gfc_tc,
               gfc_ly,
               gfc_gn,
               gfc_16,
               "(C==1)*1+(C==0)*((B==0)*(A>0)*1+(B==0)*(A==0)*0+(B>0)*0)"
))

#################### CREATE MAP beg-end years AT THRESHOLD (0 no data, 1 forest, 2 non-forest, 3 loss, 4 gain)
system(sprintf("gdal_calc.py -A %s -B %s -C %s --co COMPRESS=LZW --outfile=%s --calc=\"%s\"",
               gfc_tc,
               gfc_ly,
               gfc_gn,
               gfc_mp,
                 paste0("(C==1)*4+
                        (C==0)*((B<",as.numeric(str_sub(beg_year, -2))-1,")*(A>0)*1
                        +(B<",as.numeric(str_sub(beg_year, -2))-1,")*(A==0)*2
                        +(B>",as.numeric(str_sub(beg_year, -2))-1,")*(B<",as.numeric(str_sub(end_year, -2))-1,")*3
                        +(B>=",as.numeric(str_sub(end_year, -2))-1,")*1)
                        ")
))

#############################################################
### CROP TO COUNTRY BOUNDARIES
system(sprintf("python %s/oft-cutline_crop.py -v %s -i %s -o %s -a %s",
               scriptdir,
               paste0(gadm_dir,"gadm_",the_country,"l1.shp"),
               gfc_mp,
               gfc_mp_crop,
               "OBJECTID"
))

#############################################################
### CROP TO ONE STATE BOUNDARIES
system(sprintf("python %s/oft-cutline_crop.py -v %s -i %s -o %s -a %s",
               scriptdir,
               paste0(gadm_dir,"work_aoi_sub.shp"),
               gfc_mp_crop,
               gfc_mp_sub,
               "OBJECTID"
))

####################################################################################
####### CLIP ESA MAP TO COUNTRY BOUNDING BOX
####################################################################################
system(sprintf("gdal_translate -ot Byte -projwin %s %s %s %s -co COMPRESS=LZW %s %s",
               floor(bb@xmin),
               ceiling(bb@ymax),
               ceiling(bb@xmax),
               floor(bb@ymin),
               paste0(esa_folder,"ESACCI-LC-L4-LC10-Map-20m-P1Y-2016-v1.0.tif"),
               paste0(esa_dir,"esa.tif")
))


#############################################################
### CROP TO COUNTRY BOUNDARIES
system(sprintf("python %s/oft-cutline_crop.py -v %s -i %s -o %s -a %s",
               scriptdir,
               paste0(gadm_dir,"gadm_",the_country,"l1.shp"),
               paste0(esa_dir,"esa.tif"),
               paste0(esa_dir,"esa_crop.tif"),
               "OBJECTID"
))

#############################################################
### CROP TO ONE STATE BOUNDARIES
system(sprintf("python %s/oft-cutline_crop.py -v %s -i %s -o %s -a %s",
               scriptdir,
               paste0(gadm_dir,"work_aoi_sub.shp"),
               paste0(esa_dir,"esa_crop.tif"),
               paste0(esa_dir,"esa_sub_crop.tif"),
               "OBJECTID"
))



time_products_global <- Sys.time() - time_start


