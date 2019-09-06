using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chapter12_GaussianBlur : PostEffectBase
{
    [SerializeField] private Shader m_Shader;

    [Range(1, 4), SerializeField] private int m_Iteration = 1;
    [Range(0.2f, 3.0f), SerializeField] private float m_BlurSpread = 1f;
    [Range(1, 8), SerializeField] private int downSample = 1;

    private Material m_ShaderMaterial;
    public Material ShaderMaterial
    {
        get
        {
            m_ShaderMaterial = CreateMaterialByShader(m_Shader, m_ShaderMaterial);
            return m_ShaderMaterial;
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (ShaderMaterial != null)
        {
            int srcW = src.width / downSample;
            int scrH = src.height / downSample;

            RenderTexture texture0 = RenderTexture.GetTemporary(srcW, scrH, 0);
            texture0.filterMode = FilterMode.Bilinear;
            Graphics.Blit(src, texture0);

            for (int i = 0; i < m_Iteration; i++)
            {
                RenderTexture texture1 = RenderTexture.GetTemporary(srcW, scrH, 0);
                ShaderMaterial.SetFloat("_BlurSize", 1.0f + i * m_BlurSpread);
                
                // apply horizontal blur
                Graphics.Blit(texture0, texture1, ShaderMaterial, 0);
                
                RenderTexture.ReleaseTemporary(texture0);
                texture0 = texture1;
                texture1 = RenderTexture.GetTemporary(srcW, scrH, 0);

                // apply Vertical blur
                Graphics.Blit(texture0, texture1, ShaderMaterial, 1);
                
                RenderTexture.ReleaseTemporary(texture0);
                texture0 = texture1;
            }

            Graphics.Blit(texture0, dest);
            RenderTexture.ReleaseTemporary(texture0);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

}
