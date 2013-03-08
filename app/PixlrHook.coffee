getHookScript = (SECRETKEY) => """
  <?php
    
    parse_str($_SERVER['HTTP_REFERER'], $ref);
    
    $key="#{SECRETKEY}";
    
    if (array_key_exists("key", $ref)  and $ref["key"]  != $key) return;
    if (array_key_exists("key", $_GET) and $_GET["key"] != $key) return;
    
    if ($_GET["ping"] == "1") {
      echo "OK";
    }
    else {
      $fileName = $_GET["title"] . "." . $_GET["type"];
      $targetPath = $ref['meta'];
      
      if ($fileName != $ref["title"]) {
        $exp = explode($ref["title"], $targetPath);
        $targetPath = $exp[0] . $fileName;
      }
      
      touch($targetPath);
      $fh = fopen($targetPath, 'w') or die("can't open file");
      fwrite($fh, file_get_contents($_GET["image"]));
      fclose($fh);    
    }
    
  ?>
"""