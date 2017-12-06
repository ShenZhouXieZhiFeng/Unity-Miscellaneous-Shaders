Shader "chenjd/geomShader2"
{
	Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Value ("Value",Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom
           
            #include "UnityCG.cginc"
 
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
 
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
 
            sampler2D _MainTex;
            float4 _MainTex_ST;

			float _Value;
           
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = v.vertex;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
 
            [maxvertexcount(3)]
            void geom(triangle v2f input[3], inout TriangleStream<v2f> OutputStream)
            {
                v2f test = (v2f)0;
				float3 v1 = input[1].vertex - input[0].vertex;
				float3 v2 = input[2].vertex - input[0].vertex;
				float3 norm = normalize(cross(v1, v2));
                for(int i = 0; i < 3; i++)
                {
					float3 tempPos = input[i].vertex;
					float realTime = _Value * _SinTime.w;
					tempPos += norm * (realTime + .5 * pow(realTime, 2));
                    test.vertex = UnityObjectToClipPos(tempPos);
                    test.uv = input[i].uv;
                    OutputStream.Append(test);
                }
            }
           
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
 
                return col;
            }
            ENDCG
        }
    }
}
