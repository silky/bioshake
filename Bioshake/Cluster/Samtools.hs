{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeOperators         #-}
module Bioshake.Cluster.Samtools where

import           Bioshake
import           Bioshake.Cluster.Torque
import           Bioshake.Implicit
import           Bioshake.Internal.Samtools
import           Bioshake.TH
import           Development.Shake
import           Development.Shake.FilePath

indexRules =
  "//*.bam.bai" %> \out -> do
    let input = dropExtension out
    need [input]
    cmd "samtools index" [input] [out]

$(makeSingleCluster ''AddRGLine [''IsBam] 'buildAddRGLine)
$(makeCluster ''SortBam [''IsBam] 'buildSortBam)
$(makeCluster ''MappedOnly [''IsSam] 'buildMappedOnly)
$(makeSingleCluster ''Pileup [''IsBam, ''Referenced] 'buildPileup)
$(makeSingleCluster ''DeDup [''IsBam] 'buildDedup)
$(makeSingleCluster ''BedCov [''IsBam, ''Capture] 'buildBedCov)
