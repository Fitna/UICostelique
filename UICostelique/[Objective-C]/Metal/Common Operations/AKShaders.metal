//
//  Filters.metal
//  ScreenStitch
//
//  Created by Олег on 25.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void copyTexture(texture2d<float, access::read> inTexture [[texture(0)]],
                        texture2d<float, access::write> outTexture [[texture(1)]],
                        uint2 gid [[thread_position_in_grid]]) {
    outTexture.write(inTexture.read(gid), gid);
}


kernel void summTexture(texture2d<float, access::read> inTexture1 [[texture(0)]],
                        texture2d<float, access::read> inTexture2 [[texture(1)]],
                        texture2d<float, access::write> outTexture [[texture(2)]],
                        constant float * coeff [[buffer(0)]],
                        uint2 gid [[thread_position_in_grid]]) {
    float opacity = coeff[0];
    float4 source1 = inTexture1.read(gid) * (1 - opacity);
    float4 source2 = inTexture2.read(gid) * opacity;

    outTexture.write(source1 + source2, gid);
}


