( function _FilesFind_Extract_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  require( './aTemplateFileWriter.test.s' );
}

//

var _ = _global_.wTools;
var Parent = wTests[ 'Tools/mid/l5.test/TemplateFileWriter/Abstract' ];

_.assert( !!Parent );

//

var filesTree =
{
  'folder.abc' :
  {
    'test1.js' : "test\n.gitignore\n.travis.yml\nMakefile\nexample.js\n",
    'test2' : "var concatMap = require('concat-map');\nvar balanced = require('balanced-match');",
    'folder2.x' :
    {
      'test1.txt' : "var concatMap = require('concat-map');\nvar balanced = require('balanced-match');",
    }
  },
  'test_dir' :
  {
    'test3.js' : 'test\n.gitignore\n.travis.yml\nMakefile\nexample.js\n',
  },
  'file1' : 'Excepteur sint occaecat cupidatat non proident',
  'file' : 'abc',
  'linkToFile' : [{ hardLink : '/file' }],
  'linkToUnknown' : [{ hardLink : '/unknown' }],
  'linkToDir' : [{ hardLink : '/test_dir' }],
  'softLinkToFile' : [{ softLink : '/file' }],
  'softLinkToUnknown' : [{ softLink : '/unknown' }],
  'softLinkToDir' : [{ softLink : '/test_dir' }],
}

//

function pathFor( filePath )
{
  return '/' + filePath;
}

//

function onSuiteBegin( test )
{
  let context = this;
  Parent.onSuiteBegin.apply( this, arguments );
  context.provider = _.FileProvider.Extract({ usingExtraStat : 1, protocol : 'current' });
  let path = context.provider.path;
  context.testSuitePath = path.dirTempOpen( 'suite-' + 'TemplateFileWriter' );
}

//

function onSuiteEnd()
{
  let context = this;
  let path = this.provider.path;
  _.assert( _.mapKeys( context.provider.filesTree ).length === 1 );
  return Parent.onSuiteEnd.apply( this, arguments );
}

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

  context :
  {
    filesTree : filesTree,
    pathFor : pathFor,
    testFile : '/file1',
  },

  tests :
  {
  },

}

//

var Self = new wTestSuite( Proto ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
