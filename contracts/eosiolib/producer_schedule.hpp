#pragma once
#include <eotiolib/privileged.hpp>

#include <vector>

namespace eotio {
   /**
    *  Defines both the order, account name, and signing keys of the active set of producers.
    */
   struct producer_schedule {
      uint32_t                     version;   ///< sequentially incrementing version number
      std::vector<producer_key>    producers;
   };
} /// namespace eotio
