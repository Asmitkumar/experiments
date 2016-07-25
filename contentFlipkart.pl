	#!/usr/bin/perl
	#use strict;
	#use warnings;

	use LWP::Simple;
	use Data::Dumper;
        use JSON::XS;

	#my @urls = ("http://www.amazon.in/s/ref=sr_abn_pp_ss_1389432031?ie=UTF8&bbn=1389432031&rh=n%3A1389432031");

	my @urls = ("http://www.flipkart.com/leeco-le-2-rose-gold-32-gb/p/itmejeucxaxmnk8k?pid=MOBEJEUCS2Z4N2E2");

	#print "Here";
	#foreach my $url (@urls) {
        open FILE, "allFlipkartContentUrlsSorted.txt" or die $!;
        while(<FILE>)
         {
            my $url = $_;
	    print STDERR "Crawling $url\n";
	    my $content = get($url);
	   # my $content = `curl --silent '$url' -H 'User-Agent: Mozilla/5.0 (Macintosh; In grep OS X 10.9; rv:24.0) Gecko/20100101 Firefox/24.0' 2>/dev/null`;
	    my $fields = extractFields($content, $url);

	    #-- Randomly sleep between 1s and 5s
	    sleep (int(rand(4)) + 1);
	}

	sub extractFields {
	    my ($content, $url) = @_;
	    
	    return if $content !~ /i/;
	    my $data;
	    my @features_array;

	    #-- Extract name
	    if ($content =~ /<h1 class=\"title\"\s*itemprop=\"name\"[^>]*>([^<]+)<\/h1>/) {
	        my $name = $1;
	        $name =~ s/\s*<\/span>//sig;
	        if ($name){
	        $data->{name} = $name;
	    }
	    else{
	    	$data->{name} = "Name not present";
	    }
	}
	     
	    #-- Extract Features
	        while ($content =~ /asmit<li>([^<]+)<\/li>/g) {
	            my $line = $1;
	            $line =~ s/<\/td>//sig;
	            $line =~ s/<td class="value">/\:/sig;
	            $line =~ s/Best Sellers Rank:.*//sig;
	            #print $line;
	            #print STDERR Dumper $line;
	            if ($line){
	            push (@features_array, $line);
	        }
		    #-- Extract features present in a different part of the page
	        }
	        while ($content =~ /<td class=\"specsKey\"[^>]*>([^<]+<\/td>\s*<td class=\"specsValue\"[^>]*>[^<]+<\/td>)/g) {
	            my $line2 = $1;
	            $line2 =~ s/\s*<\/td>//sig;
	            $line2 =~ s/\s*<td class="specsValue">\s*/\: /sig;
	            $line2 =~ s/Best Sellers Rank:.*//sig;
	            #print $line;
	            #print STDERR Dumper $line;
	            if ($line2){
	            push (@features_array, $line2);
	        }
	        }
	        if (@features_array){
	        $data->{feature} = \@features_array;
	    }
	    else{
	    	$data->{feature} = "Features Not present";
	    }

	  #  #-- Extract price
	    if ($content =~ /<span class=\"selling-price omniture-field\"\s*data\-omnifield=\"eVar48\"\s*data\-eVar48=\"([^\"]+)\"/) {
	        $data->{price} = $1;
	    }
            chomp ($url);
	    $data->{url} = $url;
	        
	    #print STDERR Dumper $data;
            my $json = encode_json $data;
            print STDERR $json;
open(FH, '>>', 'allFlipkartContent.json') or die "cannot open file";
                select FH;
                print $json."\n";
	    }
	#}



