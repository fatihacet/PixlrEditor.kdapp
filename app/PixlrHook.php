<?php
  if ($_GET["ping"] == "1") {
    echo "OK";
  }
  else {
    $fileName = $_GET["title"] . "." . $_GET["type"];
    
    $ref = $_SERVER['HTTP_REFERER'];
    
    parse_str($ref, $refParsed);
    
    $targetPath = $refParsed['meta'];
    
    if ($fileName != $refparsed["title"]) {
      $exp = explode($refParsed["title"], $targetPath);
      $targetPath = $exp[0] . $fileName;
    }
    
    touch($targetPath);
    $fh = fopen($targetPath, 'w') or die("can't open file");
    fwrite($fh, file_get_contents($_GET["image"]));
    fclose($fh);
    
    # file_put_contents('Pixlr.txt', print_r($_GET, true) . "\n\n\n" .  print_r($refParsed, true) . "\n\n\n" .  print_r($targetPath, true));
  }  
?>