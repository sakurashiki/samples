#!/usr/bin/perl

print "Content-Type: text/html\n\n";
print "<!DOCTYPE html>";
print "<meta charset='utf-8'>";
print '<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">';
print "<title>sample A</title>";

my %list = (
  'aimasu' => '../db/aimasu',
  'toloveru' => '../db/toloveru',
  'bakemono' => '../db/bakemono',
  'kankore' => '../db/kankore',
  'kinsyo' => '../db/kinsyo',
  'lovelive' => '../db/lovelive',
  'toho' => '../db/toho',
  'oreimo' => '../db/oreimo'
);

print <<EOF;
<style>
body {
  margin : 0;
  background-color : gray;
}
.main {
  margin: 0 auto;
  background-color: white;
}
.sumbnail {
  background-size: cover;
  background-position: center;
  width : 100%;
  margin: 0 auto;
  height : 390px;
  display : block;
  margin : 0 auto;
  z-index: 0;
}
.header {
  z-index:1;
  position: fixed;
  width : 100%;
  margin: 0 auto;
  height: 40px;
  background-color: rgb(16,139,203);
  color: white;
  text-align: center;
  font-size: 140%;
  padding-top: 10px;
}
.article {
  padding-top: 50px;
}
.item {
  border-top: 1px dotted rgb(16,139,203);
  padding: 5px;
}
.name>img {
  display : block;
  float : left;
  width : 18%;
  margin-bottom:2px;
}
.name>.hn {
  margin-top : 3px;
  margin-left : 2%;
  margin-right: 2%;
  width : 77%;
  display : block;
  float: left;
  color: rgb(20,20,20);
}
.name>.title {
  margin-top: 5px;
  margin-left : 2%;
  margin-right: 2%;
  width : 77%;
  display : block;
  float: left;
  text-decoration:bold;
  color: rgb(100,100,100);
  font-size: 80%;
}
.clearfix {
  clear: both;
}
.command {
  margin : 2%;;
}
.command>.suki {
  width : 52%;
  background-color : rgb(16,139,203);
  float : left;
  margin-left: 2%;
  padding: 2%;
  border-radius : 50px;
  text-align : center;
  color: white;
}
.command>.cart {
  width : 30%;
  background-color : orange;
  float : left;
  margin-left: 2%;
  padding: 2%;
  border-radius: 50px;
  color: white;
  text-align : center;
}
.tags>.tag {
  border-radius : 100px;
  padding : 2%;
  margin-top:5%;
  margin-bottom:6%;
  margin-rigth : 3%;
  font-size: 90%;
  background-color : #EEE;
}
</style>
<script>
var i = 0;
window.document.onkeydown = function() {
  var e = undefined;
  if( event.keyCode === 37 ) {
    i--;
    e = document.getElementById(i);
  }
  if( event.keyCode === 39 ) {
    i++;
    e = document.getElementById(i);
  }
  if( e ) {
    var top = e.getBoundingClientRect().top + document.body.scrollTop;
    console.log(i+" - "+top);
    window.scrollTo(0,top);
    return void(0);
  }
}
</script>
EOF

my ( $target, $url ) = split /---/,$ENV{'QUERY_STRING'};

if ( $target ) {
  if ( $url ) {
    $url =~ s/__SLASH__/\//g;
    $url =~ s/__SHARP__/#/g;
    my $i = 0;
    foreach( glob $url."/*" ) {
      if( 0 < (-s $_ ) ) {
        print "<img id='".$i."' src='".$_."' style='width:100%;display:block;'/><br/>\n";
        $i++;
      }
    }
  } else {
    my $i=0;
    open NAME_LIST, '< ../seeds/nameList.txt';
    @nameList = <NAME_LIST>;
    close NAME_LIST;
    open TITLE_LIST, '< ../seeds/titleList.txt';
    @titleList = <TITLE_LIST>;
    close TITLE_LIST;
    print '<div class="main">';
    print '<div class="header">トレンド</div>';
    print '<div class="article">';
    foreach( glob $list{$target}."/*" ) {
      if( -f $_."/001.jpg" and (-s $_."/001.jpg" > 0) ) {
        my $imgpath = $_."/001.jpg";
        s/#/__SHARP__/g;
        s/\//__SLASH__/g;
        print "<div class='item'>";
        print "  <div class='name'>";
        print "    <img src='../img/".(sprintf "%02d",rand(20)).".jpg'>";
        print "    <div class='hn'>".($nameList[(rand(20))])."</div>";
        print "    <div class='title'>".($titleList[(rand(20))])."</div>";
        print "  </div>";
        print "  <div class='clearfix'></div>";
        print "  <div class='tags'>";
        if( rand(20) >= 16 ) {
          print "<span class='tag'>C89</span>";
        }
        print "  </div>";
        print "  <a href='?".$target."---".$_."'><div id='".$i."' class='sumbnail' style='background-image:url(".$imgpath.");'></div></a>\n";
        print "  <div class='command'>";
        print "    <div class='suki'>スキ!!</div>";
        print "    <div class='cart'>カートへ</div>";
        print "  </div>";
        print "  <div class='clearfix'></div>";
        print '</div>';
        $i++;
      }
    }
    print '</div>';
    print '</div>';
  }
} else {
  print '<h1>タグを選んでください</h1>';
  print '<ul>';
  foreach( keys %list ) {
    my $path = $list{$_};
    print '<li><a href="?'.$_.'">'.$_.' -- '.`ls -l ${path} | wc -l  `.'</a></li>';
  }
  print '</ul>';
}
