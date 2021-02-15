cd $1

if [ -f write_dbs.tcl ]; then   
    rm write_dbs.tcl            
fi                              

find . -name "*.lib" | while read fname
do
	libname=$(echo $fname | sed 's/_130b//; s/.lib//; s/.\///')
	dbname=$(echo $fname | sed 's/.lib/.db/')

	echo "read_lib $fname" >> write_dbs.tcl
	echo "write_lib ${libname}_lib -format db -output $dbname" >> write_dbs.tcl
	echo "remove_lib $libname" >> write_dbs.tcl
done

echo "exit" >> write_dbs.tcl

lc_shell -f write_dbs.tcl > lc.log
