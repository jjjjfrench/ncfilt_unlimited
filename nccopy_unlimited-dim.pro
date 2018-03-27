PRO nccopy_unlimited-dim

; original path and file name
path_in='/home/kshaffe5/research/data_files'
file_in='/DIMG.base170116195242.2DS.V.cdf'

; path and file name for new file
path_out='/home/kshaffe5/research/new_data_files'
file_out=file_in

; create a new netcdf file
ncid_out=ncdf_create(path_out+file_out,/Clobber, /NETCDF4_FORMAT)

; open the original file to be copied
ncid_in=ncdf_open(path_in+file_in,/NOWRITE)

;get information about the original file
info = ncdf_inquire(ncid_in)
  
; get name and size of dimensions in the original netcdf file
for i = 0, info.ndims-1 do begin
  ncdf_diminq, ncid_in, i, dimname, dimsize
  dimid=ncdf_dimdef(ncid_out,dimname,dimsize)
endfor

; copy over global attributes from original to new file
for i = 0, info.ngatts-1 do begin
  ncdf_name=ncdf_attname(ncid_in, /GLOBAL, i)
  gattid=ncdf_attcopy(ncid_in, ncdf_name, ncid_out, /IN_GLOBAL, /OUT_GLOBAL)
endfor
                         
; copy over names of variables                                               
for i = 0, info.nvars-1 do begin
  varinfo=ncdf_varinq(ncid_in, i)
  CASE varinfo.datatype OF    
    'DOUBLE' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /DOUBLE)
    'SHORT' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /SHORT)
    'BYTE' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /BYTE)
    'SHUFFLE' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /SHUFFLE) 
    'STRING' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /STRING) 
    'FLOAT' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /FLOAT) 
    'CONTIGUOUS' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /CONTIGUOUS) 
    'GZIP' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /GZIP) 
    'INT' :  varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /SHORT) 
    'LONG' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /LONG) 
    'CHAR' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /CHAR)
    'CHUNK_DIMENSIONS' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /CHUNK_DIMENSIONS) 
    'UBYTE' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /UBYTE)
    'UINT64' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /UINT64)
    'ULONG' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /ULONG)
    'USHORT' : varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /USHORT)
    ELSE: Print, varinfo.datatype
     ENDCASE
  
  ;varid=ncdf_vardef(ncid_out, varinfo.name, varinfo.dim, /DOUBLE)
endfor

; takes the file out of define mode and into data mode
NCDF_CONTROL, ncid_out, /NOFILL
NCDF_CONTROL, ncid_out, /ENDEF

; copy over data from original file to new file
for i=0, info.nvars-1 do begin
  ncdf_varget, ncid_in, i, value  
   
  ncdf_varput, ncid_out, i, value  
endfor                       

; close both files
ncdf_close, ncid_in
ncdf_close, ncid_out


END
