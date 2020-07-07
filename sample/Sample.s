
if( typeof module !== 'undefined' )
{
  require( 'wTools' );
  require( '..' /* 'wtemplatefilewriter' */ );
}

var _ = wTools;

var template =
{
  'tmp.tmp' :
  {
    'test1.txt' : 'Test file1 content',
    'test2.txt' : 'Test file2 content',
  }
}

var writer = new wTemplateFileWriter({ template : template });

writer.form();
