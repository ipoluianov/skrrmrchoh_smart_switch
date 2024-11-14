// SelectDialog.tsx
import React from 'react';

interface SelectDialogProps {
  options: string[];
  onSelect: (value: string) => void;
  onClose: () => void;
}

const SelectDialog: React.FC<SelectDialogProps> = ({ options, onSelect, onClose }) => {
  const handleKeyDown = (event: React.KeyboardEvent<HTMLUListElement>) => {
    if (event.key === 'Escape') {
      onClose();
    }
  };

  return (
    <div style={{ position: 'absolute', background: '#fff', border: '1px solid #ddd', borderRadius: '4px', zIndex: 100 }}>
      <ul onKeyDown={handleKeyDown} tabIndex={0} style={{ listStyleType: 'none', padding: 0, margin: 0 }}>
        {options.map((option, index) => (
          <li
            key={index}
            onClick={() => onSelect(option)}
            style={{ padding: '8px', cursor: 'pointer', borderBottom: '1px solid #ddd' }}
          >
            {option}
          </li>
        ))}
      </ul>
      <button onClick={onClose} style={{ display: 'block', marginTop: '8px' }}>
        Закрыть
      </button>
    </div>
  );
};

export default SelectDialog;
