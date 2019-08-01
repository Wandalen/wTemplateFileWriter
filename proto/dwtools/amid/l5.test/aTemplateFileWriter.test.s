( function _TemplateFileWriter_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( 'wTools' );

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
  _.assert( Object.keys( this.hub.providersWithProtocolMap ).length === 1, 'Hub should have single registered provider at the end of testing' );
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
  _.sure( _.entityIdentical( _.mapKeys( hub.providersWithProtocolMap ), [ 'current' ] ), test.name, 'has not restored hub!' );
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
  let path = context.provider.path;
  let testPath = path.join( context.testSuitePath, 'routine-' + test.name );

  var template =
  {
    'tmp.tmp' :
    {
      'test1.txt' : 'Test file1 content',
      'test2.txt' : 'Test file2 content',
    }
  };

  /* tests */

  test.case = 'base test';

  var writer = _.TemplateFileWriter({ fileProvider : provider, currentPath : path, template : template });
  var got = provider.filesFind( filePath );
  var expected = [ '.' ];
  test.identical( got, expected );
}


// --
// declare
// --

var Self =
{

  name : 'Tools/mid/l5.test/TemplateFileWriter/Abstract',
  abstract : 0,
  silencing : 1,
  routineTimeOut : 60000,

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
