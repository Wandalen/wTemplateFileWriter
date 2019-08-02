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

//

function softLinkIsSupported()
{
  let context = this;
  let path = context.provider.path;

  if( Config.platform === 'nodejs' && typeof process !== undefined )
  if( process.platform === 'win32' )
  {
    var allow = false;
    var dir = path.join( context.testSuitePath, 'softLinkIsSupported' );
    var srcPath = path.join( dir, 'src' );
    var dstPath = path.join( dir, 'dst' );

    _.fileProvider.filesDelete( dir );
    _.fileProvider.fileWrite( srcPath, srcPath );

    try
    {
      _.fileProvider.softLink({ dstPath : dstPath, srcPath : srcPath, throwing : 1, sync : 1 });
      allow = _.fileProvider.isSoftLink( dstPath );
    }
    catch( err )
    {
      logger.error( err );
    }

    return allow;
  }

  return true;
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
      'test2.txt' : '{ "template file.txt" : "content of template file"}',
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
  var got = provider.filesFindRecursive( testPath + '/tmp.tmp' );
  var expected = './test1.txt';
  test.identical( got[ 1 ].relative, expected );

  test.case = 'base test, name';
  var writer = _.TemplateFileWriter
  ({
    dstPath : testPath,
    template : template,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( testPath + '/tmp.tmp' );
  var expected = './folder/file.js';
  test.identical( got[ 4 ].relative, expected );


  test.case = 'without dstPath';
  var writer = _.TemplateFileWriter
  ({
    template : template,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( provider.path.current() + '/tmp.tmp' );
  var expected = './test1.txt';
  test.identical( got[ 1 ].relative, expected );

  test.case = 'without dstPath, name';
  var writer = _.TemplateFileWriter
  ({
    template : template,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( provider.path.current() + '/tmp.tmp' );
  var expected = './folder/file.js';
  test.identical( got[ 4 ].relative, expected );

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
  var got = provider.filesFindRecursive( testPath + '/tmp.tmp' );
  var expected = './test1.txt';
  test.identical( got[ 1 ].relative, expected );

  test.case = 'base test, name';
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstPath : testPath,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( testPath + '/tmp.tmp' );
  var expected = './folder/file.js';
  test.identical( got[ 4 ].relative, expected );


  test.case = 'base test';
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( provider.path.current() + '/tmp.tmp' );
  var expected = './test1.txt';
  test.identical( got[ 1 ].relative, expected );

  test.case = 'base test, name';
  var writer = _.TemplateFileWriter
  ({
    srcProvider : srcProvider,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( provider.path.current() + '/tmp.tmp' );
  var expected = './folder/file.js';
  test.identical( got[ 4 ].relative, expected );

  // test.case = 'srcTemplate';

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
