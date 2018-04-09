( function _TemplateFileWriter_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath )/*hhh*/;
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath )/*hhh*/;
  }

  var _ = _global_.wTools;

  _.include( 'wCopyable' );
  _.include( 'wFiles' );
  _.include( 'wTemplateTreeResolver' );

}

var _ = _global_.wTools;
var Parent = null;
var Self = function wTemplateFileWriter( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'TemplateFileWriter';

// --
// inter
// --

function init( o )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.instanceInit( self );

  if( self.constructor === Self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( !self.fileProvider )
  self.fileProvider = _.fileProvider;

}

//

function form()
{
  var self = this;

  _.assert( arguments.length === 0 );

  if( !self.currentPath )
  self.currentPath = self.fileProvider.pathCurrent();

  if( !self.basePath )
  self.basePath = '.';

  self.basePath = self.fileProvider.pathResolve( self.currentPath, self.basePath );

  // var mainDirPath = _.pathEffectiveMainDir();

  if( self.template === null )
  {
    try
    {
      self.templateFilePath = self.fileProvider.pathResolve( self.currentPath, self.templateFilePath || './Template.s' );
      self.template = require( _.pathNativize( self.templateFilePath ) );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }
    if( !self.template )
    throw _.errLogOnce( 'Cant find template at',_.strQuote( self.templateFilePath ) );
  }

  var config = self.configGet();

  if( !self.resolver )
  self.resolver = _.TemplateTreeResolver();
  self.resolver.tree = config;

  self.templateResolved = self.resolver.resolve( self.template );
  self.templateProvider = new _.FileProvider.SimpleStructure({ filesTree : self.templateResolved });

  self.templateProvider.readToProvider
  ({
    dstProvider : _.fileProvider,
    dstPath : self.currentPath,
    basePath : self.basePath,
    allowDeleteForRelinking : 1,
  });

}

//

function nameGet()
{
  var self = this;
  if( self.name !== null && self.name !== undefined )
  return self.name;
  return _.pathName( self.currentPath );
}

//

function configGet()
{
  var self = this;
  var name = self.nameGet();
  var result = { package : { name : name, nameLowerCased : name.toLowerCase() } };
  return result;
}

//

function exec()
{
  var self = new this.Self();
  self.form();
  return self;
}

// --
// relationships
// --

var Composes =
{
  currentPath : null,
  basePath : null,
  templateFilePath : null,
  name : null,
}

var Associates =
{
  fileProvider : null,
  resolver : null,
  template : null,
  templateResolved : null,
}

var Restricts =
{

  templateProvider : null,

}

var Statics =
{
  exec : exec,
}

// --
// proto
// --

var Proto =
{

  init : init,
  form : form,

  nameGet : nameGet,
  configGet : configGet,

  exec : exec,

  // relationships

  constructor : Self,
  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

// define

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

_[ Self.nameShort ] = _global_[ Self.name ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

if( typeof module !== 'undefined' )
if( !module.parent )
Self.exec();

})();
