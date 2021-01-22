
if( typeof module !== 'undefined' )
{
  require( 'wTools' );
  require( 'wtemplatefilewriter' );
}

let _ = wTools;

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

console.log( _.toStr( writer ) );

/* log :
wTemplateFileWriter::
{
  dst : '/mnt/home-hdd/ДокумwTemplateFileWriter',
  srcTemplatePath : null,
  name : null,
  resolving : 1
}

*/

console.log( writer.template );

/* log :
{
  'tmp.tmp': {
    'test1.txt': 'Test file1 content',
    'test2.txt': 'Test file2 content'
  }
}
*/
