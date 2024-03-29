use vars qw(%result_texis %result_texts %result_trees %result_errors 
   %result_indices %result_sectioning %result_nodes %result_menus
   %result_floats %result_converted %result_converted_errors 
   %result_elements %result_directions_text %result_indices_sort_strings);

use utf8;

$result_trees{'unknown_value'} = {
  'contents' => [
    {
      'contents' => [
        {
          'args' => [
            {
              'text' => 'unknown'
            }
          ],
          'cmdname' => 'value'
        }
      ],
      'type' => 'before_node_section'
    }
  ],
  'type' => 'document_root'
};

$result_texis{'unknown_value'} = '@value{unknown}';


$result_texts{'unknown_value'} = '';

$result_errors{'unknown_value'} = [
  {
    'error_line' => 'warning: undefined flag: unknown
',
    'file_name' => '',
    'line_nr' => 1,
    'macro' => '',
    'text' => 'undefined flag: unknown',
    'type' => 'warning'
  }
];


$result_floats{'unknown_value'} = {};



$result_converted{'plaintext'}->{'unknown_value'} = '{No value for \'unknown\'}
';


$result_converted{'html_text'}->{'unknown_value'} = '{No value for &lsquo;unknown&rsquo;}';


$result_converted{'xml'}->{'unknown_value'} = '';


$result_converted{'docbook'}->{'unknown_value'} = '';


$result_converted{'latex_text'}->{'unknown_value'} = '\\{No value for `unknown\'\\}';

1;
