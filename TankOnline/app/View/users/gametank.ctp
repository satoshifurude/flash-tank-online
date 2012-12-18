
<div id="flashy"><p>No flash loaded</p></div>

<?php
$this->Flash->init(array('width'=>800,'height'=>600));
echo $this->Flash->renderSwf('tank.swf');
?>
<?php echo $this->Flash->renderSwf('tank.swf',800,600,'flashy');?>

