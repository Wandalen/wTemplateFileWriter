( function _TemplateFileWriter_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );

  require( '../l5_mapper/TemplateFileWriter.s' );

  var waitSync = require( 'wait-sync' );

}

//

var _ = _global_.wTools;
var Parent = wTester;

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;
}

//

function onSuiteEnd()
{
  let path = this.provider.path;
  _.assert( _.strHas( this.testSuitePath, 'tmp.tmp' ) );
  path.dirTempClose( this.testSuitePath );
  this.provider.finit();
}

//

function onRoutineEnd( test )
{
  let context = this;
  let provider = context.provider;
  let path = context.provider.path;
}

//--
// tests
//--

function templateFileWriter( test )
{
  let context = this;
  let provider = context.provider;
  let testPath = context.testSuitePath;

  /* test, template */

  var template =
  {
    'tmp.tmp' :
    {
      'folder' :
      {
        'file.js' : 'console.log( "file.js" );'
      },
      'test1.txt' : 'Test file1 content',
      'test2.txt' : '{ "file.js" : "console.log( "file.js" )" }',
    }
  };

  test.case = 'base test';
  var writer = _.TemplateFileWriter
  ({
    template : template,
    dstPath : testPath,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.txt', './folder', './folder/file.js' ];
  test.identical( got, expected );

  test.case = 'base test, name';
  var writer = _.TemplateFileWriter
  ({
    dstPath : testPath,
    template : template,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.txt', './folder', './folder/file.js' ];
  test.identical( got, expected );


  test.case = 'without dstPath';
  var writer = _.TemplateFileWriter
  ({
    template : template,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : provider.path.current() + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.txt', './folder', './folder/file.js' ];
  test.identical( got, expected );

  test.case = 'without dstPath, name';
  var writer = _.TemplateFileWriter
  ({
    template : template,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : provider.path.current() + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.txt', './folder', './folder/file.js' ];
  test.identical( got, expected );

  /* srcProvider is instance of FileProvider.Extract */

  var srcProvider = _.FileProvider.Extract
  ({
    filesTree : template,
  });

  test.case = 'base test';
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstPath : testPath,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.txt', './folder', './folder/file.js' ];
  test.identical( got, expected );

  test.case = 'base test, name';
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstPath : testPath,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.txt', './folder', './folder/file.js' ];
  test.identical( got, expected );


  test.case = 'base test';
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : provider.path.current() + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.txt', './folder', './folder/file.js' ];
  test.identical( got, expected );

  test.case = 'base test, name';
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : provider.path.current() + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.txt', './folder', './folder/file.js' ];
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument in form()';
  test.shouldThrowErrorSync( function()
  {
    var write = _.templateFileWriter
    ({
      dstProvider : provider,
      template : template,
    });
    write.form( template );
  });

  test.case = 'srcProvider + template';
  test.shouldThrowErrorSync( function()
  {
    var write = _.templateFileWriter
    ({
      srcProvider : provider,
      template : template,
    });
    write.form();
  });

  test.case = 'srcProvider + srcTemplatePath';
  test.shouldThrowErrorSync( function()
  {
    var write = _.templateFileWriter
    ({
      srcProvider : provider,
      srcTemplatePath : testPath,
    });
    write.form();
  });

  test.case = 'srcProvider is instance of HardDrive';
  test.shouldThrowErrorSync( function()
  {
    var write = _.templateFileWriter
    ({
      srcProvider : _.fileProvider,
      template : template,
    });
    write.form();
  });

}

// --
// declare
// --

var Self =
{

  name : 'Tools/mid/l5.test/TemplateFileWriter/Abstract',
  abstract : 1,
  silencing : 1,
  routineTimeOut : 20000,

  onSuiteBegin,
  onSuiteEnd,
  onRoutineEnd,

  context :
  {
    provider : null,
    hub : null,
    testSuitePath : null,
  },

  tests :
  {
    templateFileWriter,
  },

};

wTestSuite( Self );

})();
