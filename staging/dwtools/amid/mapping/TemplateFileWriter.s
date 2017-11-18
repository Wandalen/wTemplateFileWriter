( function _TemplateFileWriter_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../include/dwtools/Base.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wCopyable' );
  _.include( 'wFiles' );
  _.include( 'wTemplateTreeResolver' );

}

var _ = wTools;
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

}

//

function form()
{
  var self = this;

  _.assert( arguments.length === 0 );

  if( !self.currentPath )
  self.currentPath = _.pathCurrent();

  // var mainDirPath = _.pathEffectiveMainDir();

  if( self.template === null )
  {
    try
    {

      if( !self.templateFilePath )
      self.templateFilePath = _.pathResolve( self.currentPath,'./Template.s' );
      else
      self.templateFilePath = _.pathResolve( self.currentPath,self.templateFilePath );

      self.template = require( self.templateFilePath );
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
  self.resolver = wTemplateTreeResolver();
  self.resolver.tree = config;

  var templateResolved = self.resolver.resolve( self.template );

  _.fileProvider.filesTreeWrite
  ({
    filePath : self.currentPath,
    filesTree : templateResolved,
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
  templateFilePath : null,
  name : null,
}

var Associates =
{
  resolver : null,
  template : null,
}

var Restricts =
{
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

wCopyable.mixin( Self );

//

wTools[ Self.nameShort ] = _global_[ Self.name ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

if( !module.parent )
Self.exec();

})();
