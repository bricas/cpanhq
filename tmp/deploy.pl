use lib 'lib';

require CPANHQ;
CPANHQ->model('DB')->schema->deploy;
