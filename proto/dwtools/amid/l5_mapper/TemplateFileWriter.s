( function _TemplateFileWriter_s_( ) {

'use strict';

/*
qqq :
- implement tests for TemplateFileWriter
- Use the module in Censor
- Add commands to censor:
.extract.read {-src-}
.extract.select {-terminal-}
.extract.write {-dst-}
might be glob
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../dwtools/Tools.s' );

  _.include( 'wCopyable' );
  _.include( 'wFiles' );
  _.include( 'wTemplateTreeResolver' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = null;
let Self = wTemplateFileWriter;
function wTemplateFileWriter( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'TemplateFileWriter';

// --
// inter
// --

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.workpiece.initFields( self );

  if( self.constructor === Self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( !self.dstProvider )
  self.dstProvider = _.fileProvider;

}

//

function form()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( !self.dst )
  self.dst = self.dstProvider.path.current();

  if( self.srcProvider )
  {
    _.assert( !self.template );
    _.assert( !self.srcTemplatePath );
  }
  else
  {
    _.assert( !( self.template && self.srcTemplatePath ) );
  }


  if( self.template === null && !self.srcProvider )
  {
    try
    {
      self.srcTemplatePath = _.fileProvider.path.resolve( self.srcTemplatePath || './Template.s' );
      self.template = require( _.path.path.nativize( self.srcTemplatePath ) );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }
    if( !self.template )
    throw _.errLogOnce( 'Cant read template', _.strQuote( self.srcTemplatePath ) );
  }

  let config = self.configGet();

  if( !self.resolver )
  self.resolver = _.TemplateTreeResolver({ prefixToken : '{:', postfixToken : ':}' });
  self.resolver.tree = config;

  if( !self.srcProvider )
  self.srcProvider = new _.FileProvider.Extract({ filesTree : self.template });

  _.assert( self.srcProvider instanceof _.FileProvider.Extract );

  debugger;
  self.srcProvider.filesTree = self.resolver.resolve( self.srcProvider.filesTree );
  debugger;

  self.srcProvider.filesReflectTo
  ({
    dstProvider : self.dstProvider,
    dst : self.dst,
    dstRewriting : 0,
  });

}

//

function Exec()
{
  if( Config.interpreter === 'browser' )
  return;
  let self = new this.Self();
  self.form();
  return self;
}
//

function nameGet()
{
  let self = this;
  if( self.name !== null && self.name !== undefined )
  return self.name;
  return _.path.name( self.dst );
}

//

function configGet()
{
  let self = this;
  let result = self.onConfigGet();
  return result;
}

//

function onConfigGet()
{
  let self = this;

  let name = self.nameGet();
  let lowName = name.toLowerCase();
  let highName = name.toUpperCase();
  let prefixlessName;

  // if( name[ 0 ] === 'w' )
  // prefixlessName = name.slice( 1 );
  // else
  // prefixlessName = name;
  //
  // let result = { name, lowName, highName, prefixlessName };

  let result = { name, lowName, highName };

  return result;
}

// --
// relations
// --

let Composes =
{
  dst : null,
  srcTemplatePath : null,
  name : null,
}

let Associates =
{

  srcProvider : null,
  dstProvider : null,

  resolver : null,
  template : null,

  onConfigGet : onConfigGet,

}

let Restricts =
{

}

let Statics =
{
  Exec,
}

// --
// declare
// --

let Proto =
{

  init,
  form,
  Exec,

  nameGet,
  configGet,

  // relations

  Composes,
  Associates,
  Restricts,
  Statics,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

_[ Self.shortName ] = _global_[ Self.name ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

if( typeof module !== 'undefined' )
if( !module.parent )
Self.Exec();

})();
