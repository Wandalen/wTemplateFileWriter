( function _FilesFind_Extract_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  require( './aTemplateFileWriter.test.s' );
}

//

let _ = _global_.wTools;
let Parent = wTests[ 'Tools/mid/l5.test/TemplateFileWriter/Abstract' ];

_.assert( !!Parent );

//

function onSuiteBegin( test )
{
  let context = this;
  Parent.onSuiteBegin.apply( this, arguments );
  context.provider = _.FileProvider.Extract({ usingExtraStat : 1, protocol : 'current' });
  let path = context.provider.path;
  context.testSuitePath = path.dirTempOpen( 'suite-TemplateFileWriter' );
  context.testSuitePath = context.provider.pathResolveLinkFull
  ({
    filePath : context.testSuitePath,
    resolvingSoftLink : 1,
    resolvingTextLink : 1,
  });
}

//

function onSuiteEnd()
{
  let context = this;
  let path = this.provider.path;
  return Parent.onSuiteEnd.apply( this, arguments );
}

//--
// tests
//--



// --
// declare
// --

var Proto =
{

  name : 'Tools/mid/l5.test/TemplateFileWriter/Extract',
  silencing : 1,
  abstract : 0,
  enabled : 1,

  onSuiteBegin,
  onSuiteEnd,

  tests :
  {
  },

}

//

let Self = new wTestSuite( Proto ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
