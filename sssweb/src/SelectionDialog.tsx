import React, { useState, useEffect, useRef } from 'react';

export interface Option {
  Key: string;
  Value: string;
}

interface SelectionDialogProps {
  options: Option[];
  defaultSelectedKey?: string;
  onConfirm: (selectedKey: string | null) => void;
  onCancel: () => void;
}

const SelectionDialog: React.FC<SelectionDialogProps> = ({ options, defaultSelectedKey, onConfirm, onCancel }) => {
  const [selectedIndex, setSelectedIndex] = useState<number>(0);
  const dialogRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    // Устанавливаем начальный индекс на основе defaultSelectedKey
    const defaultIndex = options.findIndex(option => option.Key === defaultSelectedKey);
    if (defaultIndex !== -1) {
      setSelectedIndex(defaultIndex);
    }
    // Устанавливаем фокус на диалог при его монтировании
    dialogRef.current?.focus();
  }, [defaultSelectedKey, options]);

  const handleKeyDown = (event: React.KeyboardEvent<HTMLDivElement>) => {
    if (event.key === 'ArrowDown') {
      setSelectedIndex((prevIndex) => (prevIndex + 1) % options.length);
    } else if (event.key === 'ArrowUp') {
      setSelectedIndex((prevIndex) => (prevIndex - 1 + options.length) % options.length);
    } else if (event.key === 'Enter') {
      onConfirm(options[selectedIndex].Key);
    } else if (event.key === 'Escape') {
      onCancel();
    }
  };

  const handleClick = (index: number) => {
    setSelectedIndex(index);
  };

  return (
    <div
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        width: '100vw',
        height: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        zIndex: 1000,
      }}
    >
      <div
        ref={dialogRef}
        tabIndex={0}
        onKeyDown={handleKeyDown}
        style={{
          width: '50%',
          maxHeight: '80%',
          backgroundColor: 'white',
          border: '1px solid #ccc',
          borderRadius: '8px',
          padding: '16px',
          boxShadow: '0 4px 8px rgba(0, 0, 0, 0.2)',
        }}
      >
        <ul style={{ listStyleType: 'none', padding: 0, margin: 0 }}>
          {options.map((option, index) => (
            <li
              key={option.Key}
              onClick={() => handleClick(index)}
              style={{
                padding: '8px',
                backgroundColor: index === selectedIndex ? '#e0e0e0' : 'white',
                cursor: 'pointer',
              }}
            >
              {option.Value}
            </li>
          ))}
        </ul>
        <div style={{ marginTop: '16px', textAlign: 'right' }}>
          <button onClick={() => onConfirm(options[selectedIndex].Key)}>OK</button>
          <button onClick={onCancel} style={{ marginLeft: '8px' }}>
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};

export default SelectionDialog;
