( function _TemplateFileWriter_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( 'Tools' );

  _.include( 'wTesting' );

  require( '../l5_mapper/TemplateFileWriter.s' );

}

//

const _ = _global_.wTools;
const Parent = wTester;

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
  // _.assert( _.strHas( this.suiteTempPath.filePath, 'tmp.tmp' ) );
  // _.assert( _.strHas( this.suiteTempPath.filePath, 'suite-TemplateFileWriter' ) );
  path.tempClose( this.suiteTempPath.filePath );
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
  let testPath = context.suiteTempPath.filePath;

  var template =
  {
    'tmp.tmp' :
    {
      'folder' :
      {
        'file.js' : 'console.log( "file.js" );'
      },
      'test1.txt' : 'Test file1 content',
      'test2.s' : 'Test file2 content',
    }
  };
  var templateFile = `const Proto = { file : 'Content of file' };\
                     \nif( typeof module !== 'undefined' )\
                     \nmodule[ 'exports' ] = Self;`;

  /* testing of rewriting existed files by templateWriter */

  test.case = 'rewriting test';
  provider.filesDelete( testPath );
  provider.fileWrite( testPath + '/tmp.tmp/test2.s', 'Should not be overwritten, test2.s' );
  provider.fileWrite( testPath + '/tmp.tmp/folder/file.js', 'Should not be overwritten, file.js' );
  var writer = _.TemplateFileWriter
  ({
    template,
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  var expected = 'Should not be overwritten, test2.s';
  var got = provider.fileRead( testPath + '/tmp.tmp/test2.s' );
  test.identical( got, expected );
  var expected1 = 'Should not be overwritten, file.js';
  var got1 = provider.fileRead( testPath + '/tmp.tmp/folder/file.js' );
  test.identical( got1, expected1 );
  var got2 = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected2 = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got2, expected2 );

  /* test, template */

  test.case = 'template, dst, dstProvider, base test';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    template,
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  //

  test.case = 'template, dst, dstProvider, name, base test';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    dst : testPath,
    template,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  //

  test.case = 'template, without dst';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    template,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : provider.path.current() + '/tmp.tmp', outputFormat : 'relative' } );
  provider.filesDelete( _.path.current() + '/tmp.tmp' );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  //

  test.case = 'template, without dst, name';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    template,
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

  test.case = 'srcProvider - instance of Extract, dst, dstProvider';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    srcProvider,
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : testPath + '/tmp.tmp', outputFormat : 'relative' } );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  //

  test.case = 'srcProvider - instance of Extract, dst, dstProvider, name';
  provider.filesDelete( testPath );
  var writer = _.TemplateFileWriter
  ({
    srcProvider,
    dst : testPath,
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
    srcProvider,
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
    srcProvider,
    dstProvider : provider,
    name : 'filename',
  });
  writer.form();
  var got = provider.filesFindRecursive( { filePath : provider.path.current() + '/tmp.tmp', outputFormat : 'relative' } );
  provider.filesDelete( _.path.current() + '/tmp.tmp' );
  var expected = [ '.', './test1.txt', './test2.s', './folder', './folder/file.js' ];
  test.identical( got, expected );

  /* resolver using */

  test.case = 'default onConfigGet';
  provider.filesDelete( testPath );
  var template =
  {
    file : '{{name }}, {{lowName}}, {{highName}}'
  };
  var writer = _.TemplateFileWriter
  ({
    template,
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  var got = provider.fileRead( testPath + '/file' );
  var name = _.path.name( testPath );
  var expected = name + ', ' + name.toLowerCase() + ', ' + name.toUpperCase();
  test.identical( got, expected );

  //

  test.case = 'custom onConfigGet';
  provider.filesDelete( testPath );
  var template =
  {
    file : '{{name }}, {{lowName}}, {{highName}}'
  };
  function configGet()
  {
    return { name : 'File', lowName : 'file', highName : 'FILE' };
  }
  var writer = _.TemplateFileWriter
  ({
    template,
    dst : testPath,
    dstProvider : provider,
    onConfigGet : configGet,
  });
  writer.form();
  var got = provider.fileRead( testPath + '/file' );
  var expected = 'File, file, FILE';
  test.identical( got, expected );


  provider.filesDelete( testPath );
  var template =
  {
    file : '{{any.key}} : {{any.value}}'
  };
  function configGet2()
  {
    return { 'any.key' : 'key', 'any.value' : 'value' };
  }
  var writer = _.TemplateFileWriter
  ({
    template,
    dst : testPath,
    dstProvider : provider,
    onConfigGet : configGet2,
  });
  writer.form();
  var got = provider.fileRead( testPath + '/file' );
  var expected = 'key : value';
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
      template,
    });
    write.form( template );
  });

  test.case = 'srcProvider + template';
  test.shouldThrowErrorSync( function()
  {
    var write = _.templateFileWriter
    ({
      srcProvider : provider,
      template,
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
      template,
    });
    write.form();
  });

}

//

function templateFileWriterLinks( test )
{
  let context = this;
  let provider = context.provider;
  let testPath = context.suiteTempPath.filePath;

  var templateFile = `const Proto = { file : 'Content of file' };\
                     \nif( typeof module !== 'undefined' )\
                     \nmodule[ 'exports' ] = Self;`;

  /* test, srcTemplatePath */

  test.case = 'without srcTemplatePath, dst, dstProvider';
  provider.filesDelete( testPath );
  var defaultTemplate = _.path.current() + '/Template.s';
  _.fileProvider.fileWrite( defaultTemplate, templateFile );
  var writer = _.TemplateFileWriter
  ({
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( defaultTemplate );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  //

  test.case = 'srcTemplatePath is hard link, dst, dstProvider';
  provider.filesDelete( testPath );
  var pathToTemp = _.fileProvider.path.tempOpen( 'tmp.tmp' );
  var customTemplate = pathToTemp + '/Template.s';
  _.fileProvider.fileWrite( customTemplate, templateFile );
  var writer = _.TemplateFileWriter
  ({
    srcTemplatePath : customTemplate,
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( pathToTemp );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  //

  test.case = 'srcTemplatePath is soft link, dst, dstProvider';
  provider.filesDelete( testPath );
  var pathToTemp = _.fileProvider.path.tempOpen( 'tmp.tmp' );
  var customTemplate = pathToTemp + '/Template.s';
  var softlink = pathToTemp + '/softlink';
  _.fileProvider.fileWrite( customTemplate, templateFile );
  _.fileProvider.softLink( softlink, customTemplate );
  var writer = _.TemplateFileWriter
  ({
    srcTemplatePath : softlink,
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( pathToTemp );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  //

  test.case = 'srcTemplatePath is double soft link, dst, dstProvider';
  provider.filesDelete( testPath );
  var pathToTemp = _.fileProvider.path.tempOpen( 'tmp.tmp' );
  var customTemplate = pathToTemp + '/Template.s';
  var softlink = pathToTemp + '/softlink';
  _.fileProvider.fileWrite( customTemplate, templateFile );
  _.fileProvider.softLink( softlink, customTemplate );
  _.fileProvider.softLink( pathToTemp + '/softlink2', softlink );
  var writer = _.TemplateFileWriter
  ({
    srcTemplatePath : pathToTemp + '/softlink2',
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( pathToTemp );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  //

  test.case = 'srcTemplatePath is soft link, relative';
  provider.filesDelete( testPath );
  var pathToTemp = _.fileProvider.path.tempOpen( 'tmp.tmp' );
  var customTemplate = pathToTemp + '/Template.s';
  var softlink = pathToTemp + '/softlink';
  _.fileProvider.fileWrite( customTemplate, templateFile );
  _.fileProvider.softLink( softlink, '../Template.s' );
  _.fileProvider.softLink( pathToTemp + '/softlink2', softlink );
  var writer = _.TemplateFileWriter
  ({
    srcTemplatePath : pathToTemp + '/softlink2',
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( pathToTemp );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  /* test, text links */

  test.case = 'srcTemplatePath is text link, dst, dstProvider';
  provider.filesDelete( testPath );
  var pathToTemp = _.fileProvider.path.tempOpen( 'tmp.tmp' );
  var customTemplate = pathToTemp + '/Template.s';
  var textlink = pathToTemp + '/textlink';
  _.fileProvider.fileWrite( customTemplate, templateFile );
  _.fileProvider.textLink( textlink, customTemplate );
  _.fileProvider.fieldPush( 'usingTextLink', 1 );
  var pathResolved = _.fileProvider.pathResolveTextLink( { filePath : textlink } );
  var writer = _.TemplateFileWriter
  ({
    srcTemplatePath : pathResolved,
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( pathToTemp );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  //

  test.case = 'srcTemplatePath is double text link, dst, dstProvider';
  provider.filesDelete( testPath );
  var pathToTemp = _.fileProvider.path.tempOpen( 'tmp.tmp' );
  var customTemplate = pathToTemp + '/Template.s';
  var textlink = pathToTemp + '/textlink';
  _.fileProvider.fileWrite( customTemplate, templateFile );
  _.fileProvider.textLink( textlink, customTemplate );
  _.fileProvider.textLink( pathToTemp + '/textlink2', textlink );
  _.fileProvider.fieldPush( 'usingTextLink', 1 );
  var pathResolved = _.fileProvider.pathResolveTextLink( { filePath : pathToTemp + '/textlink2' } );
  pathResolved = _.fileProvider.pathResolveTextLink( textlink );
  var writer = _.TemplateFileWriter
  ({
    srcTemplatePath : pathResolved,
    dst : testPath,
    dstProvider : provider,
  });
  writer.form();
  _.fileProvider.filesDelete( pathToTemp );
  var got = provider.filesFindRecursive( { filePath : testPath, outputFormat : 'relative' } );
  var expected = [ '.', './file' ];
  test.identical( got, expected );

  //

  test.case = 'srcTemplatePath is text link, relative';
  provider.filesDelete( testPath );
  var pathToTemp = _.fileProvider.path.tempOpen( 'tmp.tmp' );
  var customTemplate = pathToTemp + '/Template.s';
  var textlink = pathToTemp + '/textlink';
  _.fileProvider.fileWrite( customTemplate, templateFile );
  _.fileProvider.textLink( { dstPath : textlink, srcPath : '../Template.s' } );
  _.fileProvider.fieldPush( 'usingTextLink', 1 );
  var pathResolved = _.fileProvider.pathResolveTextLink( { filePath : textlink } );
  var writer = _.TemplateFileWriter
  ({
    srcTemplatePath : textlink + '/' + pathResolved,
    dst : testPath,
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

  test.case = 'broken soft link';
  test.shouldThrowErrorSync( function()
  {
    var write = _.templateFileWriter
    ({
      dstProvider : provider,
      dst : testPath,
      srcTemplatePath : _.fileProvider.softLink( pathToTemp, testPath ),
    });
    write.form();
  });

  test.case = 'not allowed text links';
  test.shouldThrowErrorSync( function()
  {
    var write = _.templateFileWriter
    ({
      dstProvider : provider,
      dst : testPath,
      srcTemplatePath : _.fileProvider.textLink( pathToTemp + '/link', testPath + '/file2.s' ),
    });
    write.form();
  });
}

// --
// declare
// --

const Proto =
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
    suiteTempPath : null,
  },

  tests :
  {
    templateFileWriter,
    templateFileWriterLinks,
  },

};

wTestSuite( Self );

})();
