// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Alan's Volume Rendering" {
	Properties {
        _Centre("Centre", Vector) = (0.0, 0.0, 0.0)
        _Radius("Radius", Range(0, 10)) = 0.5
	}
	SubShader {
		Pass {
            Blend SrcAlpha OneMinusSrcAlpha // Traditional transparency

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

            float3 _Centre;
            float _Radius;

            struct v2f {
                float4 pos : SV_POSITION;	// Clip space
                float3 wPos : TEXCOORD1;	// World position
            };

            #define STEPS 64
            #define STEP_SIZE 0.01
            #define MIN_DISTANCE 0.0001

            float sphereDistance(float3 p) {
                return distance(p, _Centre) - _Radius;
            }
            
            fixed4 raymarch(float3 position, float3 direction) {
                for (int i = 0; i < STEPS; i++) {
                    float distance = sphereDistance(position);
                    if (distance < MIN_DISTANCE) {
                        fixed f = i / (float) STEPS;
                        return fixed4(f, 0, 0, 1);
                    }
                    position += direction * distance;
                }

                return 0;
            }

            v2f vert(appdata_full v) {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float3 worldPosition = i.wPos;
                float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
                return raymarch(worldPosition, viewDirection);
            }
			ENDCG
		}
	}
}
