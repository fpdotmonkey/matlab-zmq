function test_zmq_getsockopt
  % let's just create a dummy socket
  ctx = zmq_ctx_new();
  socket = zmq_socket(ctx, 'ZMQ_REP');

  % Table with the default values for options
  defaultOptions = { ...
    {'ZMQ_TYPE'                , 'ZMQ_REP' } , ...
    {'ZMQ_RCVMORE'             , 0         } , ...
    {'ZMQ_SNDHWM'              , 1000      } , ...
    {'ZMQ_RCVHWM'              , 1000      } , ...
    {'ZMQ_AFFINITY'            , 0         } , ...
  ... %  {'ZMQ_IDENTITY'            , ''        } , ... % issues on octave
    {'ZMQ_RATE'                , 100       } , ...
    {'ZMQ_RECOVERY_IVL'        , 10000     } , ...
    {'ZMQ_RCVBUF'              , 0         } , ...
    {'ZMQ_LINGER'              , -1        } , ...
    {'ZMQ_RECONNECT_IVL'       , 100       } , ...
    {'ZMQ_RECONNECT_IVL_MAX'   , 0         } , ...
    {'ZMQ_BACKLOG'             , 100       } , ...
    {'ZMQ_MAXMSGSIZE'          , -1        } , ...
    {'ZMQ_MULTICAST_HOPS'      , 1         } , ...
    {'ZMQ_RCVTIMEO'            , -1        } , ...
    {'ZMQ_SNDTIMEO'            , -1        } , ...
    {'ZMQ_IPV6'                , 0         } , ...
    {'ZMQ_IPV4ONLY'            , 1         } , ...
    {'ZMQ_IMMEDIATE'           , 0         },  ...
    {'ZMQ_TCP_KEEPALIVE'       , -1        } , ...
    {'ZMQ_TCP_KEEPALIVE_IDLE'  , -1        } , ...
    {'ZMQ_TCP_KEEPALIVE_CNT'   , -1        } , ...
    {'ZMQ_TCP_KEEPALIVE_INTVL' , -1        } , ...
    {'ZMQ_MECHANISM'           , 'ZMQ_NULL'} , ...
    {'ZMQ_PLAIN_USERNAME'      , ''        } , ...
    {'ZMQ_PLAIN_PASSWORD'      , ''        } , ...
  };

  % This loop will test all the socket options against the default values listed
  % above.
  %
  % Once the socket is fresh and unused, all the options should remain with the
  % default values.
  for n = 1:(length(defaultOptions)-1)
    option = defaultOptions{n}{1};
    value = defaultOptions{n}{2};

    response = zmq_getsockopt(socket, option);

    if ~ischar(value)
      condition = response == value;
      % display
      response = num2str(response);
      value = num2str(value);
    else
      condition = strcmp(value, response);
      % display
      response = ['"' response '"'];
      value = ['"' value '"'];
    end

    assert(condition, '%s should be %s, %s given.', option, value, response);
  end

  % close session
  zmq_ctx_shutdown(ctx);
  %zmq_ctx_term(ctx); % once ZMQ_LINGER is set to -1 by default, `zmq_ctx_term`
                      % will block until socket is closed, but this operation is
                      % not implemented yet.
end