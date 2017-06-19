#!/usr/bin/perl
use JSON;

open(logfile, "/var/log/auth.log");
$bl = 0;

while( $line = <logfile> ){
	if( $bl ){
		print ",\n";
	}else{
		print "[\n";
		$bl = 1;
	}
	$_ = $line;
	if($_ =~ m/(\w+\s\d+\s\d+.\d+.\d+)\s(\w+)\s/g){
		$datetime = $1;
		$workstation = $2;
		if($_ =~ m/([\w-]+)(?:\[\d+\].\s\w+\(\w+.\w+\).\s)?/g){
			$service = $1;
			if($_ =~ m/(?:[\s\[\]\d:]*)?(?:pam_unix\([\w-:]+\):?\s)?(.*)/g){
				$message = $1;
			}
			%data = ("datetime" => $datetime, "workstation" => $workstation, "service" => $service, "message" => $message);
			$json_obj = encode_json \%data;
			print "$json_obj\n";
		}
	}
}
print "]\n";
