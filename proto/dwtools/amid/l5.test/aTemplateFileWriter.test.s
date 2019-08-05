( function _TemplateFileWriter_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );

  require( '../l5_mapper/TemplateFileWriter.s' );

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

  var template =
  {
    'tmp.tmp' :
    {
      'folder' :
      {
        'file.js' : 'console.log( "file.js" );'
      },
      'test1.txt' : 'Test file1 content',
      'test2.s' : "Test file2 content",
    }
  };
  var templateFile = "var Self = { file : 'Content of file' };\
                     \nif( typeof module !== 'undefined' )\
                     \nmodule[ 'exports' ] = Self;";

  /* test, template */

  test.case = 'template, dstPath, dstProvider, base test';
  var writer = _.TemplateFileWriter
  ({
    template : template,
    dstPath : testPath,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  //

  test.case = 'template, dstPath, dstProvider, name, base test';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    dstPath : testPath,
    template : template,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  //

  test.case = 'template, without dstPath';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    template : template,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : provider.path.current() + '/tmp.tmp', outputFormat : 'relative' } );
  provider.filesDelete( _.path.current() + '/tmp.tmp' );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  //

  test.case = 'template, without dstPath, name';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    template : template,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : provider.path.current() + '/tmp.tmp', outputFormat : 'relative' } );
  provider.filesDelete( _.path.current() + '/tmp.tmp' );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  /* srcProvider is instance of FileProvider.Extract */

  var srcProvider = _.FileProvider.Extract
  ({
    filesTree : template,
  });

  test.case = 'srcProvider - instance of Extract, dstPath, dstProvider';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstPath : testPath,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  //

  test.case = 'srcProvider - instance of Extract, dstPath, dstProvider, name';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstPath : testPath,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  //

  test.case = 'srcProvider - instance of Extract, dstProvider';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : provider.path.current() + '/tmp.tmp', outputFormat : 'relative' } );
  provider.filesDelete( _.path.current() + '/tmp.tmp' );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  //

  test.case = 'srcProvider - instance of Extract, dstProvider, name';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : provider.path.current() + '/tmp.tmp', outputFormat : 'relative' } );
  provider.filesDelete( _.path.current() + '/tmp.tmp' );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  /* test, srcTemplatePath */

  test.case = 'without srcTemplatePath, dstPath, dstProvider';
  provider.filesDelete( testPath );
  _.fileProvider.fileWrite( _.path.current() + '/Template.s', templateFile );
  var writer = _.TemplateFileWriter
  ({
    dstPath : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( _.path.current() + '/Template.s' );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  test.case = 'srcTemplatePath is hard link, dstPath, dstProvider';
  provider.filesDelete( testPath );
  var pathToTemp = _.fileProvider.path.dirTempOpen( 'tmp.tmp' );
  _.fileProvider.fileWrite( pathToTemp + '/test2.s', templateFile );
  var writer = _.TemplateFileWriter
  ({
    srcTemplatePath : pathToTemp + '/test2.s',
    dstPath : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( pathToTemp );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  //

  test.case = 'srcTemplatePath is soft link, dstPath, dstProvider';
  provider.filesDelete( testPath );
  var pathToTemp = _.fileProvider.path.dirTempOpen( 'tmp.tmp' );
  _.fileProvider.fileWrite( pathToTemp + '/file2.s', templateFile );
  _.fileProvider.softLink( pathToTemp + '/softlink', pathToTemp + '/file2.s' );
  var writer = _.TemplateFileWriter
  ({
    srcTemplatePath : pathToTemp + '/softlink',
    dstPath : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( pathToTemp );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  //

  test.case = 'srcTemplatePath is double soft link, dstPath, dstProvider';
  provider.filesDelete( testPath );
  var pathToTemp = _.fileProvider.path.dirTempOpen( 'tmp.tmp' );
  _.fileProvider.fileWrite( pathToTemp + '/file2.s', templateFile );
  _.fileProvider.softLink( pathToTemp + '/softlink', pathToTemp + '/file2.s' );
  _.fileProvider.softLink( pathToTemp + '/softlink2', pathToTemp + '/softlink' );
  var writer = _.TemplateFileWriter
  ({
    srcTemplatePath : pathToTemp + '/softlink2',
    dstPath : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( pathToTemp );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument in routine form()';
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

  test.case = 'broken soft link';
  test.shouldThrowErrorSync( function()
  {
    var write = _.templateFileWriter
    ({
      dstProvider : provider,
      dstPath : testPath,
      srcTemplatePath : _.fileProvider.softLink( pathToTemp, testPath ),
    });
    write.form();
  });

  test.case = 'using of text link';
  test.shouldThrowErrorSync( function()
  {
    var write = _.templateFileWriter
    ({
      dstProvider : provider,
      dstPath : testPath,
      srcTemplatePath : _.fileProvider.textLink( pathToTemp + '/link', testPath + '/file2.s' ),
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
    testSuitePath : null,
  },

  tests :
  {
    templateFileWriter,
  },

};

wTestSuite( Self );

})();
